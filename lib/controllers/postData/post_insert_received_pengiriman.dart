// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class InsertReceivedPengiriman extends GetxController {
  // fungsi insert penerimaan produk dari pengiriman stok
  Future<void> connectAPI(
    String? idTo,
    String? userIdFrom,
    String? cabangIdFrom,
    String? cabangIdTo,
    String? produkId,
    String? stokId,
    String? namaBarang,
    String? kodeBarang,
    int qty,
    String? satuan,
    int hargaBarang,
  ) async {
    try {} catch (e) {
      var response = await http.post(
        Uri.parse('$baseUrl/pengiriman/$userIdFrom/get-by-owner/received-stok'),
        body: json.encode({
          '_id': idTo,
          'userId': userIdFrom,
          'from': cabangIdFrom,
          'to': cabangIdTo,
          'produkId': produkId,
          'stokId': stokId,
          'tanggal': DateTime.now().toString(),
          'code': kodeBarang,
          'name': namaBarang,
          'qty': qty,
          'status': "proses"
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
      snackbarNotif.success('Success', 'Pengiriman telah masuk daftar proses');
      //
      print(e);
    }
  }
}
