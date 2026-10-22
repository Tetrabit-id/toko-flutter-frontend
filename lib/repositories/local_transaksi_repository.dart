import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/kasir.dart';
import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Transaksi kasir & laporan untuk paket offline.
class LocalTransaksiRepository extends GetxController {
  // Format: INV-{yyMMdd}-{4 char deviceId}-{HHmmss}
  // Berbasis waktu (bukan urutan dari DB), karena di paket subscription
  // transaksi yang sudah terkirim dihapus dari HP; urutan bisa terulang.
  Future<String> newNoInvoice() async {
    var device = (await deviceId.getId()).toUpperCase().padRight(4, '0');
    var now = DateTime.now();
    return 'INV-${DateFormat('yyMMdd').format(now)}-${device.substring(0, 4)}-${DateFormat('HHmmss').format(now)}';
  }

  // Simpan transaksi, item pesanan, potong stok, kasbon & poin member
  // dalam satu DB transaction: semua tersimpan, atau tidak sama sekali.
  // pending = true (subscription saat offline): masuk antrean kirim ke server.
  Future<void> checkout({
    String? userId,
    bool pending = false,
    String metode = 'cash',
    required String noInvoice,
    required String date,
    String? discountName,
    String? discountUnit,
    num? discountAmount,
    required num subJumlahTransaksi,
    required num jumlahPembayaran,
    required num jumlahTransaksi,
    required num kembalian,
    required List<Kasir> items,
    Map? member,
    bool kasbon = false,
  }) async {
    var db = await localDb.db;
    var transaksiId = localDb.newId();
    userId ??= token.read('_id');

    await db.transaction((txn) async {
      await txn.insert('transaksi', {
        '_id': transaksiId,
        'userId': userId,
        'name': token.read('name'),
        'noInvoice': noInvoice,
        'cabangId': localDb.cabangId,
        'date': date,
        'discountName': discountName,
        'discountUnit': discountUnit,
        'discountAmount': discountAmount,
        'subJumlahTransaksi': subJumlahTransaksi,
        'jumlahPembayaran': jumlahPembayaran,
        'jumlahTransaksi': jumlahTransaksi,
        'kembalian': kembalian,
        'metode': kasbon ? 'kasbon' : metode,
        'membershipsId': member?['_id'],
        'memberId': member?['memberId'],
        'pending': pending ? 1 : 0,
        'createdAt': localDb.now(),
      });

      for (var item in items) {
        await txn.insert('pesanan', {
          '_id': localDb.newId(),
          'userId': userId,
          'noInvoice': noInvoice,
          'cabangId': localDb.cabangId,
          'stokId': item.stokId,
          'produkId': item.produkId,
          'code': item.kodeBarang,
          'name': item.namaBarang,
          'harga': item.hargaBarangStok,
          'qty': item.qtyPembelian,
          'total': item.totalHarga,
        });
        await txn.rawUpdate(
          'UPDATE stok SET qty = qty - ?, updatedAt = ? WHERE _id = ?',
          [item.qtyPembelian, localDb.now(), item.stokId],
        );
      }

      if (member == null) return;

      if (kasbon) {
        await txn.insert('kasbon', {
          '_id': localDb.newId(),
          'userId': userId,
          'cabangId': localDb.cabangId,
          'membershipsId': member['_id'],
          'memberId': member['memberId'],
          'transaksiId': transaksiId,
          'note': '',
          'date': date,
          'status': 'Belum dibayar',
          'pending': pending ? 1 : 0,
          'createdAt': localDb.now(),
        });
      }

      await txn.rawUpdate(
        'UPDATE memberships SET poin = poin + 100 WHERE _id = ?',
        [member['_id']],
      );
    });
  }

  // Bentuk sama dengan GET /transaksi/.../all/cabang
  // (subscription: cache server dulu, lalu transaksi yang belum terkirim)
  Future<List<Map<String, dynamic>>> getTransaksi() async {
    var db = await localDb.db;
    return db.query('transaksi', orderBy: 'pending, createdAt');
  }

  // Transaksi subscription yang belum terkirim, untuk digabung ke laporan
  Future<List<Map<String, dynamic>>> getPending() async {
    var db = await localDb.db;
    return db.query('transaksi', where: 'pending = 1', orderBy: 'createdAt');
  }

  Future<void> cacheTransaksi(List rows) =>
      localDb.replaceCache('transaksi', rows);

  // Item pesanan untuk popup invoice & cetak ulang struk
  Future<List<Map<String, dynamic>>> getPesananByInvoice(String noInv) async {
    var db = await localDb.db;
    return db.query('pesanan', where: 'noInvoice = ?', whereArgs: [noInv]);
  }
}
