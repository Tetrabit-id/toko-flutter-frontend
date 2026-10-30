// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetReportProduk extends GetxController {
  final dataProduk = List.empty().obs;

  // Pendapatan per produk antara dua tanggal (yyyy-MM-dd), terbesar dulu.
  // Bentuk item: {name, code, qty, total}
  Future<List> getApi(String startDate, String endDate) async {
    if (paket.isOffline) {
      dataProduk.assignAll(
          await localTransaksi.getPendapatanPerProduk(startDate, endDate));
      return dataProduk;
    }
    if (koneksi.terputus) return dataProduk;

    try {
      var idOwner = token.read('role') != 'admin'
          ? token.read('parentId')
          : token.read('_id');
      var response = await http.get(
        Uri.parse('$baseUrl/produk/$idOwner/get-by-owner/report'
            '?startDate=$startDate&endDate=$endDate'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data laporan produk
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataProduk;
      }

      // Server mengirim semua produk beserta pesanannya; yang tidak terjual
      // dibuang, total dihitung dari pesanan
      List produk = (data as Map<String, dynamic>)['data'] ?? [];
      var hasil = produk
          .map((p) {
            List pesanan = p['pesanan'] ?? [];
            return {
              'name': p['name'],
              'code': p['code'],
              'qty': p['produkTerjual'] ?? 0,
              'total': pesanan.fold<num>(0, (a, e) => a + (e['total'] ?? 0)),
            };
          })
          .where((p) => (p['qty'] as num) > 0)
          .toList()
        ..sort((a, b) => (b['total'] as num).compareTo(a['total'] as num));

      dataProduk.assignAll(hasil);
      return dataProduk;
    } catch (e) {
      print(e);
    }

    return dataProduk;
  }
}
