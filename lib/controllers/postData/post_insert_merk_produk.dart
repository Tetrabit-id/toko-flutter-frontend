// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertMerkProdukAPI extends GetxController {
  // fungsi insert katagori produk
  Future<void> connectAPI(
    String? userId,
    String? code,
    String? name,
  ) async {
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
