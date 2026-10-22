// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/state_global.dart';

class UpdateAkunAPI extends GetxController {
  Future<void> connectAPI(String? name, String? toko) async {
    // Akun tersimpan di server, jadi perubahan butuh internet (kedua paket)
    if (!await koneksi.check()) {
      snackbarNotif.unsuccess(
          'Tidak ada koneksi', 'Edit akun membutuhkan internet');
      return;
    }

    try {
      var response = await http.put(
          Uri.parse('$baseUrl/users/${token.read('_id')}'),
          body: json.encode({'name': name, 'store': toko}),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var data = jsonDecode(response.body);

      // Update Akun Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Update Akun Success
      Get.back();
      snackbarNotif.success('Success', 'Akun telah diupdate');
      //

      // Get Akun for update local storage
      var getResponse = await http.get(
          Uri.parse('$baseUrl/users/${token.read('_id')}'),
          headers: {'Authorization': 'Bearer ${token.read('token')}'});

      var getData = jsonDecode(getResponse.body);

      // Get Data Akun Gagal
      if (getResponse.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${getResponse.statusCode}',
          '${(getData['message']).toString().capitalizeFirst}',
        );

        return;
      }

      // Get Data Success
      var userData = (getData as Map<String, dynamic>)['data'];

      // Remove local storage name & store
      token.remove('name');
      token.remove('store');

      // Insert local storage name & store
      await token.write('name', userData['name']);
      await token.write('store', userData['store']);
    } catch (e) {
      print(e);
    }
  }
}
