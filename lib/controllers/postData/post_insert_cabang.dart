// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:http/http.dart' as http;

import '../../routes/state_global.dart';

class InsertCabangAPI extends GetxController {
  TextEditingController nmCbNewC = TextEditingController();
  TextEditingController noTelpCbNewC = TextEditingController();
  TextEditingController alamatCbNewC = TextEditingController();

  Future<void> connectAPI(
    String? name,
    String? alamat,
    String noTelp,
  ) async {
    if (koneksi.butuhInternet()) return;

    try {
      var response = await http.post(Uri.parse('$baseUrl/cabang'),
          body: json.encode({
            'userId': token.read('_id'),
            'name': name,
            'alamat': alamat,
            'noTeleponAdmin': noTelp,
          }),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Insert Cabang Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return Get.offAndToNamed(RouteName.firstPageMobile);
      }

      // Insert Success
      snackbarNotif.success('Success', 'Cabang telah ditambahkan');

      nmCbNewC.clear();
      noTelpCbNewC.clear();
      alamatCbNewC.clear();
    } catch (e) {
      print(e);
    }
  }
}
