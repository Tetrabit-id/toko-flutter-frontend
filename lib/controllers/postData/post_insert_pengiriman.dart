// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class InsertPengirimanAPI extends GetxController {
  // fungsi insert pengiriman stok produk
  Future<void> connectAPI(
    String? userId,
    String? cabangIdTo,
    String? stokId,
    String? namaBarang,
    String? kodeBarang,
    int qty,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/pengiriman/$userId/get-by-owner/direct'),
        body: json.encode({
          'cabangId': cabangIdTo,
          'stokId': stokId,
          'tanggal': DateTime.now().toString(),
          'codeProduct': kodeBarang,
          'nameProduct': namaBarang,
          'qtyProduct': qty,
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      //Insert Pengiriman Stok Produk
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return;
      }

      // Insert Pengiriman Stok Produk Success
      Get.back();
      snackbarNotif.success('Success', 'Pengiriman telah masuk daftar proses');
      //
    } catch (e) {
      print(e);
    }
  }
}
