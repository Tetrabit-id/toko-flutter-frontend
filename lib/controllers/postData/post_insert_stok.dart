// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class InsertStokAPI extends GetxController {
  // fungsi insert stok produk
  Future<void> connectAPI(
    String? userId,
    String? cabangId,
    String? produkId,
    String? produkKategoriId,
    String? produkMerkId,
    String? namaBarang,
    String? kodeBarang,
    int qty,
    String? satuan,
    int hargaBarang,
    int hargaBeli,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/stok-cabang'),
        body: json.encode({
          'userId': userId,
          'cabangId': cabangId,
          'produkId': produkId,
          'produkKategoriId': produkKategoriId,
          'produkMerkId': produkMerkId,
          'name': namaBarang,
          'code': kodeBarang,
          'qty': qty,
          'satuan': satuan,
          'harga': hargaBarang,
          'hargaModal': hargaBeli,
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Insert Produk Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return;
      }

      // Insert Produk Success
      snackbarNotif.success('Success', 'Produk telah ditambahkan');
      //
    } catch (e) {
      print(e);
    }
  }
}
