// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Produk, stok, kategori & merk untuk paket offline.
class LocalStokRepository extends GetxController {
  // Bentuk sama dengan GET /stok-cabang/.../mobile: stok + objek `produk`
  Future<List<Map<String, dynamic>>> getStok({String? cabangId}) async {
    var db = await localDb.db;
    var rows = await db.rawQuery('''
      SELECT s.*, p.file AS produkFile
      FROM stok s LEFT JOIN produk p ON p._id = s.produkId
      WHERE ? IS NULL OR s.cabangId = ?
      ORDER BY s.name COLLATE NOCASE''', [cabangId, cabangId]);

    return rows.map((row) {
      var stok = Map<String, dynamic>.from(row)
        ..remove('produkFile')
        ..remove('produkJson');
      // Cache subscription menyimpan objek produk dari server apa adanya
      stok['produk'] = row['produkJson'] != null
          ? jsonDecode(row['produkJson'] as String)
          : {
              '_id': row['produkId'],
              'code': row['code'],
              'name': row['name'],
              'file': row['produkFile'],
            };
      return stok;
    }).toList();
  }

  // Paket subscription: simpan stok satu cabang dari server sebagai cache
  Future<void> cacheStok(String? cabangId, List rows) async {
    await localDb.replaceCache(
      'stok',
      rows.map((row) => {...row, 'produkJson': row['produk']}).toList(),
      where: cabangId == null ? '1 = 1' : 'cabangId = ?',
      whereArgs: cabangId == null ? null : [cabangId],
    );
  }

  // Pesan error jika gagal, null jika berhasil
  Future<String?> insertProduk({
    String? produkKategoriId,
    String? produkMerkId,
    required String code,
    required String name,
    required int qty,
    String? satuan,
    required int harga,
    required int hargaModal,
    String? file,
  }) async {
    var db = await localDb.db;
    var produkId = localDb.newId();
    var foto = await _simpanFoto(file);

    try {
      await db.transaction((txn) async {
        await txn.insert('produk', {
          '_id': produkId,
          'userId': token.read('_id'),
          'code': code,
          'name': name,
          'file': foto,
          'createdAt': localDb.now(),
        });
        await txn.insert('stok', {
          '_id': localDb.newId(),
          'userId': token.read('_id'),
          'cabangId': localDb.cabangId,
          'produkId': produkId,
          'produkKategoriId': produkKategoriId,
          'produkMerkId': produkMerkId,
          'name': name,
          'code': code,
          'qty': qty,
          'satuan': satuan,
          'harga': harga,
          'hargaModal': hargaModal,
          'createdAt': localDb.now(),
          'updatedAt': localDb.now(),
        });
      });
    } on DatabaseException catch (e) {
      _hapusFoto(foto);
      if (e.isUniqueConstraintError()) return 'Kode barang $code sudah dipakai';
      return e.toString();
    }
    return null;
  }

  Future<void> updateStok({
    required String stokId,
    String? produkId,
    String? name,
    required int qty,
    String? satuan,
    required int harga,
    required int hargaModal,
  }) async {
    var db = await localDb.db;
    await db.transaction((txn) async {
      await txn.update(
        'stok',
        {
          'name': name,
          'qty': qty,
          'satuan': satuan,
          'harga': harga,
          'hargaModal': hargaModal,
          'updatedAt': localDb.now(),
        },
        where: '_id = ?',
        whereArgs: [stokId],
      );
      await txn.update('produk', {'name': name},
          where: '_id = ?', whereArgs: [produkId]);
    });
  }

  // Hapus produk beserta stoknya
  Future<void> deleteProduk(String? produkId) async {
    var db = await localDb.db;
    var produk =
        await db.query('produk', where: '_id = ?', whereArgs: [produkId]);
    await db.transaction((txn) async {
      await txn.delete('stok', where: 'produkId = ?', whereArgs: [produkId]);
      await txn.delete('produk', where: '_id = ?', whereArgs: [produkId]);
    });
    if (produk.isNotEmpty) _hapusFoto(produk.first['file'] as String?);
  }

  Future<List<Map<String, dynamic>>> getKategori() async {
    var db = await localDb.db;
    return db.query('kategori', orderBy: 'name COLLATE NOCASE');
  }

  Future<void> insertKategori(String? code, String? name) async {
    var db = await localDb.db;
    await db.insert('kategori', {
      '_id': localDb.newId(),
      'userId': token.read('_id'),
      'code': code,
      'name': name,
      'image': '',
    });
  }

  // Pesan error jika gagal, null jika berhasil
  Future<String?> deleteKategori(String? id) async {
    var db = await localDb.db;
    var dipakai = await db.query('stok',
        where: 'produkKategoriId = ?', whereArgs: [id], limit: 1);
    if (dipakai.isNotEmpty) return 'Kategori masih dipakai barang di stok';
    await db.delete('kategori', where: '_id = ?', whereArgs: [id]);
    return null;
  }

  Future<List<Map<String, dynamic>>> getMerk() async {
    var db = await localDb.db;
    return db.query('merk', orderBy: 'name COLLATE NOCASE');
  }

  Future<void> insertMerk(String? code, String? name) async {
    var db = await localDb.db;
    await db.insert('merk', {
      '_id': localDb.newId(),
      'userId': token.read('_id'),
      'code': code,
      'name': name,
    });
  }

  // Pesan error jika gagal, null jika berhasil
  Future<String?> deleteMerk(String? id) async {
    var db = await localDb.db;
    var dipakai = await db.query('stok',
        where: 'produkMerkId = ?', whereArgs: [id], limit: 1);
    if (dipakai.isNotEmpty) return 'Merk masih dipakai barang di stok';
    await db.delete('merk', where: '_id = ?', whereArgs: [id]);
    return null;
  }

  // File dari image_picker ada di folder cache yang bisa dihapus sistem,
  // jadi disalin ke folder dokumen aplikasi. Web tidak punya folder aplikasi,
  // jadi foto disimpan sebagai data URI di kolom `file`.
  Future<String?> _simpanFoto(String? path) async {
    if (path == null || path.isEmpty) return null;
    try {
      if (kIsWeb) {
        var foto = XFile(path);
        return UriData.fromBytes(await foto.readAsBytes(),
                mimeType: foto.mimeType ?? 'image/jpeg')
            .toString();
      }
      var dir = Directory(
          join((await getApplicationDocumentsDirectory()).path, 'produk'));
      await dir.create(recursive: true);
      var copy = await File(path)
          .copy(join(dir.path, '${localDb.newId()}${extension(path)}'));
      return copy.path;
    } catch (e) {
      print(e);
    }
    return null;
  }

  void _hapusFoto(String? path) {
    if (path == null || kIsWeb) return;
    File(path).delete().catchError((e) {
      print(e);
      return File(path);
    });
  }
}
