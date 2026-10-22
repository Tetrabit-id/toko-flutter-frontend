// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/kasir.dart';
import '../routes/base_url.dart';
import '../routes/state_global.dart';

// Pembayaran online (QRIS / VA / e-wallet) lewat Midtrans Snap, khusus paket
// subscription. Server Key hanya ada di backend; harga dihitung ulang server
// dari data stok, aplikasi cukup mengirim stokId + qty.
class MidtransService extends GetxController {
  // Balikan: {orderId, amount, snapToken, redirectUrl}, atau null jika gagal
  Future<Map<String, dynamic>?> createSnap({
    required String noInvoice,
    required List<Kasir> items,
    num discount = 0,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/payments/midtrans/snap'),
        body: json.encode({
          'noInvoice': noInvoice,
          'cabangId': token.read('cabangId'),
          // diskon persen sudah dihitung jadi rupiah di kasir
          'discountUnit': 'rp',
          'discountAmount': discount.round(),
          'items': items
              .map((item) => {'stokId': item.stokId, 'qty': item.qtyPembelian})
              .toList(),
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Gagal membuat pembayaran
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return null;
      }

      return (data as Map<String, dynamic>)['data'];
    } catch (e) {
      print(e);
      snackbarNotif.unsuccess(
          'Tidak ada koneksi', 'Pembayaran online membutuhkan internet');
    }
    return null;
  }

  // pending | paid | failed | refunded, atau null jika gagal cek
  Future<String?> status(String orderId) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/payments/midtrans/$orderId/status'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );
      if (response.statusCode != 200) return null;

      var data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      return data['status'];
    } catch (e) {
      print(e);
    }
    return null;
  }
}
