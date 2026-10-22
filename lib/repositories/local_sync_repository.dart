import 'package:get/get.dart';

import '../routes/state_global.dart';

// Antrean (outbox) paket subscription: data yang dibuat saat offline
// (pending = 1) dikirim ke POST /sync/transaksi, lalu dihapus dari HP
// setelah server menerimanya.
class LocalSyncRepository extends GetxController {
  static final _objectId = RegExp(r'^[0-9a-fA-F]{24}$');

  Future<int> countPending() async {
    var db = await localDb.db;
    var rows = await db.rawQuery('''
      SELECT
        (SELECT COUNT(*) FROM memberships WHERE pending = 1) +
        (SELECT COUNT(*) FROM transaksi WHERE pending = 1) +
        (SELECT COUNT(*) FROM kasbon WHERE pending = 1) +
        (SELECT COUNT(*) FROM rekap_kas WHERE pending = 1) AS jumlah''');
    return rows.first['jumlah'] as int;
  }

  // Server memproses: pelanggan → transaksi → kasbon → rekap kas.
  // `_id` lokal dikirim sebagai clientId (idempotency key).
  // Maks. `limit` data per jenis (server membatasi 200 data per request).
  // Yang pernah ditolak dikirim belakangan, agar tidak menghalangi yang baru.
  Future<Map<String, List>> buildBatch({int limit = 50}) async {
    var db = await localDb.db;
    const urutan = 'syncError IS NOT NULL, createdAt';

    var pelanggan = await db.query('memberships',
        where: 'pending = 1', orderBy: urutan, limit: limit);
    var transaksi = await db.query('transaksi',
        where: 'pending = 1', orderBy: urutan, limit: limit);
    var kasbon = await db.query('kasbon',
        where: 'pending = 1', orderBy: urutan, limit: limit);
    var rekapKas = await db.query('rekap_kas',
        where: 'pending = 1', orderBy: urutan, limit: limit);

    var transaksiPayload = <Map<String, dynamic>>[];
    for (var t in transaksi) {
      var items = await db.query('pesanan',
          where: 'noInvoice = ?', whereArgs: [t['noInvoice']]);
      var discount = _int(t['discountAmount']);

      transaksiPayload.add({
        'clientId': t['_id'],
        'name': t['name'],
        'noInvoice': t['noInvoice'],
        'cabangId': t['cabangId'],
        'date': t['date'],
        'discountName': t['discountName'],
        // Diskon persen sudah dihitung jadi rupiah di kasir; dikirim sebagai
        // rupiah agar total di server sama persis dengan yang dibayar.
        'discountUnit': 'rp',
        'discountAmount': discount,
        'jumlahPembayaran': _int(t['jumlahPembayaran']),
        'kembalian': _int(t['kembalian']),
        ..._member(t['membershipsId']),
        'poin': t['membershipsId'] == null ? 0 : 100,
        // server memeriksa pembayaran midtrans untuk noInvoice ini sudah lunas
        'metode': t['metode'] == 'midtrans' ? 'midtrans' : 'cash',
        'items': items
            .map((i) => {
                  'stokId': i['stokId'],
                  'produkId': i['produkId'],
                  'code': i['code'],
                  'name': i['name'],
                  'harga': _int(i['harga']),
                  'qty': _int(i['qty']),
                })
            .toList(),
      });
    }

    return {
      'pelanggan': pelanggan
          .map((p) => {
                'clientId': p['_id'],
                'cabangId': p['cabangId'],
                'memberId': p['memberId'],
                'nik': p['nik'],
                'name': p['name'],
                'email': p['email'],
                'phone': p['phone'],
                'address': p['address'],
                // poin lokal berasal dari transaksi offline, yang poinnya
                // sudah dikirim per transaksi; jangan dihitung dua kali
                'poin': 0,
              })
          .toList(),
      'transaksi': transaksiPayload,
      'kasbon': kasbon
          .map((k) => {
                'clientId': k['_id'],
                'cabangId': k['cabangId'],
                ..._member(k['membershipsId']),
                'memberId': k['memberId'],
                'transaksiClientId': k['transaksiId'],
                'note': k['note'],
                'date': k['date'],
                'status': k['status'],
              })
          .toList(),
      'rekapKas': rekapKas
          .map((r) => {
                'clientId': r['_id'],
                'cabangId': r['cabangId'],
                'karyawanId': r['karyawanId'],
                'date': r['date'],
                'kasAwal': _int(r['kasAwal']),
                'kasAkhir': _int(r['kasAkhir']),
                'selisih': _int(r['selisih']),
              })
          .toList(),
    };
  }

  // Member dari server punya ObjectId; member yang dibuat offline punya UUID
  // dan dikenali server lewat clientId pelanggan.
  Map<String, dynamic> _member(Object? id) {
    if (id == null) return {};
    return _objectId.hasMatch('$id')
        ? {'membershipsId': id}
        : {'pelangganClientId': id};
  }

  int _int(Object? value) => value is num ? value.round() : 0;

  // Hapus yang sudah diterima server; tandai yang ditolak beserta alasannya.
  Future<void> applyResult(List accepted, List rejected) async {
    var db = await localDb.db;
    await db.transaction((txn) async {
      for (var clientId in accepted) {
        var transaksi = await txn.query('transaksi',
            where: '_id = ? AND pending = 1', whereArgs: [clientId]);
        if (transaksi.isNotEmpty) {
          await txn.delete('pesanan',
              where: 'noInvoice = ?',
              whereArgs: [transaksi.first['noInvoice']]);
          await txn.delete('transaksi',
              where: '_id = ?', whereArgs: [clientId]);
        }
        for (var table in ['memberships', 'kasbon', 'rekap_kas']) {
          await txn.delete(table,
              where: '_id = ? AND pending = 1', whereArgs: [clientId]);
        }
      }

      for (var r in rejected) {
        for (var table in ['memberships', 'transaksi', 'kasbon', 'rekap_kas']) {
          await txn.update(table, {'syncError': '${r['reason']}'},
              where: '_id = ? AND pending = 1', whereArgs: [r['clientId']]);
        }
      }
    });
  }
}
