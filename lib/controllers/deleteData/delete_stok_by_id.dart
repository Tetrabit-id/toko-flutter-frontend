// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteStokAPI extends GetxController {
  Future<void> connectAPI(
    String? idStok,
    String? idProduk,
  ) async {
    // Paket offline: hapus produk lokal (stok ikut terhapus)
    if (paket.isOffline) {
      await localStok.deleteProduk(idProduk);
      return;
    }
    if (koneksi.butuhInternet()) return;

    try {
      var response = await http.delete(
          Uri.parse('$baseUrl/stok-cabang/$idStok'),
          body: json.encode({}),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Delete Produk Gagal
      if (response.statusCode != 200) {
        Get.snackbar(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
        return;
      }

      // Delete stok Success, lanjut delete katagori produk
      deleteApiUpdateProduk.connectAPI(idProduk);
      // end
    } catch (e) {
      print(e);
    }
  }
}
