// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/routes/state_global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetReportProduk extends GetxController {
  final dataProduk = List.empty().obs;

  Future<List> getApi() async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/produk/${token.read('_id')}/get-by-owner/report'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pelanggan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataProduk;
      }

      if (dataProduk.isNotEmpty) {
        dataProduk.clear();
        dataProduk.refresh();
      }

      var produk = (data as Map<String, dynamic>)['data'];
      dataProduk.addAll(produk);

      return dataProduk;
    } catch (e) {
      print(e);
    }

    return dataProduk;
  }
}
