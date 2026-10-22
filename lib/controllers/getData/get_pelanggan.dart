// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetPelangganAPI extends GetxController {
  final dataPelanggan = List.empty().obs;
  final dataPelangganById = List.empty().obs;

  // Function Get Data Pelanggan
  Future<List> getApi() async {
    try {
      var response = await http.get(
        Uri.parse(
            '$baseUrl/memberships/${token.read('_id')}/get-by-owner/all/cabang'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pelanggan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataPelanggan;
      }
      //

      if (dataPelanggan.isNotEmpty) {
        dataPelanggan.clear();
        dataPelanggan.refresh();
      }

      var pelangganData = (data as Map<String, dynamic>)['data'];
      dataPelanggan.addAll(pelangganData);
      return dataPelanggan;
    } catch (e) {
      print(e);
    }
    return dataPelanggan;
  }

  // Function Get Data Pelanggan
  Future<List> getByIdApi(String idMember) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/memberships/$idMember'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pelanggan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataPelangganById;
      }
      //

      if (dataPelangganById.isNotEmpty) {
        dataPelangganById.clear();
        dataPelangganById.refresh();
      }

      var pelangganData = (data as Map<String, dynamic>)['data'];
      dataPelangganById.add(pelangganData);
      return dataPelangganById;
    } catch (e) {
      print(e);
    }
    return dataPelangganById;
  }
}
