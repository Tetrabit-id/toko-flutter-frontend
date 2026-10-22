// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/cabang.dart';
import '../../routes/base_url.dart';

class GetCabangAPI extends GetxController {
  final dataCabangOwner = List<Cabang>.empty().obs;

  Cabang? getCabangById(String id) {
    for (var i = 0; i < dataCabangOwner.length; i++) {
      if (dataCabangOwner[i].id == id) {
        return dataCabangOwner[i];
      }
    }

    return null;
  }

  // Function Get Data Cabang
  Future<List> getAPI() async {
    var idOwner = token.read('_id');
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/cabang/$idOwner/get-by-owner'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data cabang
      if (response.statusCode != 200) {
        Get.snackbar(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
          duration: const Duration(seconds: 4),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
        return dataCabangOwner;
      }
      //

      if (dataCabangOwner.isNotEmpty) {
        dataCabangOwner.clear();
        dataCabangOwner.refresh();
      }

      List cabangData = (data as Map<String, dynamic>)['data'];

      for (var e in cabangData) {
        dataCabangOwner.add(Cabang(
          id: e['_id'],
          name: e['name'],
          alamat: e['alamat'],
          noTelp: e['noTelponAdmin'],
        ));
      }
      return dataCabangOwner;
    } catch (e) {
      print(e);
    }
    return dataCabangOwner;
  }
}
