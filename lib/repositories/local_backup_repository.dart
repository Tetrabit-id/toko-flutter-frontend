// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Backup & restore data paket offline, untuk pindah HP.
// Satu file .json berisi semua tabel lokal + foto produk (base64).
class LocalBackupRepository extends GetxController {
  static const format = 'toko-offline-backup';
  static const tables = [
    'produk',
    'stok',
    'kategori',
    'merk',
    'transaksi',
    'pesanan',
    'memberships',
    'kasbon',
    'rekap_kas',
  ];

  // Buat file backup di folder sementara, siap dibagikan
  Future<File> export() async {
    var db = await localDb.db;
    var data = <String, List>{};
    for (var table in tables) {
      data[table] = await db.query(table);
    }

    var foto = <String, String>{};
    for (var produk in data['produk']!) {
      var path = produk['file'] as String?;
      if (path == null || !await File(path).exists()) continue;
      foto[basename(path)] = base64.encode(await File(path).readAsBytes());
    }

    var now = DateTime.now();
    var backup = {
      'format': format,
      'version': await db.getVersion(),
      'userId': token.read('_id'),
      'store': token.read('store'),
      'createdAt': now.toIso8601String(),
      'tables': data,
      'files': foto,
    };

    var store = '${token.read('store') ?? 'toko'}'
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-')
        .toLowerCase();
    var file = File(join((await getTemporaryDirectory()).path,
        'backup-$store-${DateFormat('yyyyMMdd-HHmm').format(now)}.json'));
    await file.writeAsString(jsonEncode(backup));
    await token.write('lastBackup', now.toIso8601String());
    return file;
  }

  // Ganti seluruh data lokal dengan isi backup.
  // Pesan error jika gagal, null jika berhasil.
  Future<String?> restore(File file) async {
    Map<String, dynamic> backup;
    try {
      backup = jsonDecode(await file.readAsString());
    } catch (e) {
      print(e);
      return 'File bukan backup Toko';
    }

    if (backup['format'] != format) return 'File bukan backup Toko';
    if (backup['userId'] != token.read('_id')) {
      return 'Backup ini milik akun lain (${backup['store'] ?? '-'})';
    }

    var db = await localDb.db;
    Map tablesData = backup['tables'] ?? {};
    Map files = backup['files'] ?? {};

    // Foto produk ditulis ulang ke folder HP ini; path lama tidak berlaku lagi
    var fotoDir = Directory(
        join((await getApplicationDocumentsDirectory()).path, 'produk'));
    await fotoDir.create(recursive: true);
    var fotoBaru = <String, String>{};
    for (var entry in files.entries) {
      var target = File(join(fotoDir.path, entry.key));
      await target.writeAsBytes(base64.decode(entry.value));
      fotoBaru[entry.key] = target.path;
    }

    try {
      await db.transaction((txn) async {
        for (var table in tables) {
          // Hanya kolom yang ada di DB versi aplikasi ini
          var columns = (await txn.rawQuery('PRAGMA table_info($table)'))
              .map((c) => c['name'] as String)
              .toSet();

          await txn.delete(table);
          for (Map row in tablesData[table] ?? []) {
            var values = {
              for (var entry in row.entries)
                if (columns.contains(entry.key)) entry.key as String: entry.value,
            };
            if (table == 'produk' && values['file'] != null) {
              values['file'] = fotoBaru[basename(values['file'] as String)];
            }
            await txn.insert(table, values);
          }
        }
      });
    } catch (e) {
      print(e);
      return 'Restore gagal, data lama tidak berubah';
    }
    return null;
  }
}
