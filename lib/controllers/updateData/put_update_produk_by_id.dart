// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/state_global.dart';

class UpdateProdukAPI extends GetxController {
  Future<void> connectAPI(
    String? stokId,
    String? userId,
    String? cabangId,
    String? produkId,
    String? namaBarang,
    int qty,
    String? satuan,
    int hargaBarang,
    int hargaBeli,
  ) async {
    try {
      var response = await http.put(Uri.parse('$baseUrl/stok-cabang/$stokId'),
          body: json.encode({
            '_id': stokId,
            'userId': userId,
            'cabangId': cabangId,
            'produkId': produkId,
            'name': namaBarang,
            'qty': qty,
            'satuan': satuan,
            'harga': hargaBarang,
            'hargaModal': hargaBeli,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Update Produk Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Update Success
      Get.back();
      snackbarNotif.success('Success', 'Produk telah diupdate');

      //
    } catch (e) {
      print(e);
    }
  }
}
