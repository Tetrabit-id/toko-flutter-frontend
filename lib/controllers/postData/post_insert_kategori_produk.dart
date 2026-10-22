// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertKategoriProdukAPI extends GetxController {
  // fungsi insert katagori produk
  Future<void> connectAPI(
    String? userId,
    String? code,
    String? name,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/produk-kategori/$userId/get-by-owner/insert'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer ${token.read('token')}',
        'Content-Type': 'multipart/form-data'
      });

      // if (file != '') {
      //   var dataImg = http.MultipartFile(
      //     'file',
      //     File(file!).readAsBytes().asStream(),
      //     File(file).lengthSync(),
      //     filename: file.split('/').last,
      //   );

      //   request.files.add(dataImg);
      // }

      var kategori = json.encode({
        'userId': userId,
        'code': code,
        'name': name,
        'image': '',
      });

      request.fields['data'] = kategori;

      var response = await request.send();
      var result = await http.Response.fromStream(response);
      var data = jsonDecode(result.body);

      // Insert Produk Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return;
      }

      await getApiKategoriProduk.getApi();
      getApiKategoriProduk.dataKategoriProduk.refresh();

      // Apabila sudah ada 1 data maka bisa menampilkan message
      if (getApiKategoriProduk.dataKategoriProduk.length > 1) {
        Get.back();
        snackbarNotif.success('Success', 'Kategori produk telah ditambahkan');
      }
      //
    } catch (e) {
      print(e);
    }
  }
}
