import 'package:get/get.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Rekap kas (kas awal / tutup buku) untuk paket offline, serta cache &
// antrean rekap kas paket subscription saat offline.
// Paket offline hanya punya owner, jadi karyawanId = id owner.
class LocalRekapKasRepository extends GetxController {
  Future<List<Map<String, dynamic>>> getRekapKas() async {
    var db = await localDb.db;
    return db.query('rekap_kas', orderBy: 'createdAt');
  }

  // pending = true (subscription saat offline): masuk antrean kirim ke server.
  Future<void> insertRekapKas(int kasAwal,
      {bool pending = false, String? cabangId}) async {
    var db = await localDb.db;
    await db.insert('rekap_kas', {
      '_id': localDb.newId(),
      'karyawanId': token.read('_id'),
      'cabangId': cabangId == null || cabangId.isEmpty
          ? localDb.cabangId
          : cabangId,
      'kasAwal': kasAwal,
      'kasAkhir': 0,
      'selisih': 0,
      'pending': pending ? 1 : 0,
      'date': DateTime.now().toString().substring(0, 10),
      'createdAt': localDb.now(),
      'updatedAt': localDb.now(),
    });
  }

  Future<void> updateRekapKas(String id, int? kasAkhir, int? selisih) async {
    var db = await localDb.db;
    await db.update(
      'rekap_kas',
      {'kasAkhir': kasAkhir, 'selisih': selisih, 'updatedAt': localDb.now()},
      where: '_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRekapKas(String? id) async {
    var db = await localDb.db;
    await db.delete('rekap_kas', where: '_id = ?', whereArgs: [id]);
  }

  Future<bool> isPending(String? id) async {
    var db = await localDb.db;
    var rows = await db.query('rekap_kas',
        where: '_id = ? AND pending = 1', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }

  Future<void> cacheRekapKas(List rows) =>
      localDb.replaceCache('rekap_kas', rows);

  Future<List<Map<String, dynamic>>> getPending() async {
    var db = await localDb.db;
    return db.query('rekap_kas', where: 'pending = 1', orderBy: 'createdAt');
  }
}
