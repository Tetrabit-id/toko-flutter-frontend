import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Pelanggan (member), poin & kasbon untuk paket offline.
class LocalPelangganRepository extends GetxController {
  Future<List<Map<String, dynamic>>> getPelanggan() async {
    var db = await localDb.db;
    return db.query('memberships', orderBy: 'name COLLATE NOCASE');
  }

  // Dicari dari member ID (hasil scan kartu NFC / ketik manual) atau _id
  Future<Map<String, dynamic>?> getPelangganById(String id) async {
    var db = await localDb.db;
    var rows = await db.query('memberships',
        where: 'memberId = ? OR _id = ?', whereArgs: [id, id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  // Pesan error jika gagal, null jika berhasil
  // pending = true (subscription saat offline): masuk antrean kirim ke server.
  Future<String?> insertPelanggan({
    bool pending = false,
    String? cabangId,
    String? memberId,
    String? nik,
    String? email,
    String? name,
    String? phone,
    String? address,
  }) async {
    var db = await localDb.db;
    try {
      await db.insert('memberships', {
        '_id': localDb.newId(),
        'userId': token.read('_id'),
        'cabangId': cabangId == null || cabangId.isEmpty
            ? localDb.cabangId
            : cabangId,
        'memberId': memberId == null || memberId.isEmpty
            ? await _newMemberId()
            : memberId,
        'email': email,
        'nik': nik,
        'name': name,
        'phone': phone,
        'address': address,
        'poin': 0,
        'pending': pending ? 1 : 0,
        'createdAt': localDb.now(),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) return 'Member ID sudah terdaftar';
      return e.toString();
    }
    return null;
  }

  Future<void> deletePelanggan(String? id) async {
    var db = await localDb.db;
    await db.delete('memberships', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> updatePoin(String id, int poin) async {
    var db = await localDb.db;
    await db.update('memberships', {'poin': poin},
        where: '_id = ?', whereArgs: [id]);
  }

  // Bentuk sama dengan GET /kasbon/.../all/cabang
  Future<List<Map<String, dynamic>>> getKasbon() async {
    var db = await localDb.db;
    return db.query('kasbon', orderBy: 'pending, createdAt');
  }

  Future<List<Map<String, dynamic>>> getPendingKasbon() async {
    var db = await localDb.db;
    return db.query('kasbon', where: 'pending = 1', orderBy: 'createdAt');
  }

  Future<void> cacheKasbon(List rows) => localDb.replaceCache('kasbon', rows);

  Future<bool> isPending(String? id) async {
    var db = await localDb.db;
    var rows = await db.query('memberships',
        where: '_id = ? AND pending = 1', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }

  // memberId kosong disimpan sebagai NULL, karena kolomnya UNIQUE
  Future<void> cachePelanggan(List rows) => localDb.replaceCache(
      'memberships',
      rows
          .map((row) => {
                ...row,
                if (row['memberId'] == '') 'memberId': null,
              })
          .toList());

  Future<List<Map<String, dynamic>>> getPending() async {
    var db = await localDb.db;
    return db.query('memberships', where: 'pending = 1');
  }

  // Tanpa kartu NFC, member ID dibuat di HP: MBR-{4 char deviceId}-{yyMMddHHmmss}
  // Berbasis waktu agar tidak bentrok walau ada member yang dihapus/terkirim.
  Future<String> _newMemberId() async {
    var device = (await deviceId.getId()).toUpperCase().padRight(4, '0');
    return 'MBR-${device.substring(0, 4)}-${DateFormat('yyMMddHHmmss').format(DateTime.now())}';
  }
}
