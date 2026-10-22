// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertMerkProdukAPI extends GetxController {
  // fungsi insert katagori produk
  Future<void> connectAPI(
    String? userId,
    String? code,
    String? name,
  ) async {
    // Paket offline: disimpan lokal
    if (paket.isOffline) {
      await localStok.insertMerk(code, name);
      await getApiMerkProduk.getApi();
      if (getApiMerkProduk.dataMerkProduk.length > 1) {
        Get.back();
        snackbarNotif.success('Success', 'Merk produk telah ditambahkan');
      }
      return;
    }
    if (koneksi.butuhInternet()) return;

    try {
      var response = await http.post(Uri.parse('$baseUrl/produk-merk'),
          body: json.encode({
            'userId': userId,
            'code': code,
            'name': name,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Insert Produk Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return;
      }

      await getApiMerkProduk.getApi();
      getApiMerkProduk.dataMerkProduk.refresh();

      // Apabila sudah ada 1 data maka bisa menampilkan message
      if (getApiMerkProduk.dataMerkProduk.length > 1) {
        Get.back();
        snackbarNotif.success('Success', 'Merk produk telah ditambahkan');
      }
      //
    } catch (e) {
      print(e);
    }
  }
}
