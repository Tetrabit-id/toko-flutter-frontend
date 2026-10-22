// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetUsersKaryawanAPI extends GetxController {
  final dataUKaryawan = List.empty().obs;

  // Function Get Data Karyawan
  Future<List> getApi() async {
    var emailBase64 = token.read('role') == 'admin'
        ? base64Url.encode(utf8.encode(token.read('email')))
        : base64Url.encode(utf8.encode(token.read('parent')));
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/users/$emailBase64/email'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data karyawan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataUKaryawan;
      }
      //

      if (dataUKaryawan.isNotEmpty) {
        dataUKaryawan.clear();
        dataUKaryawan.refresh();
      }

      var userData = (data as Map<String, dynamic>)['data'];
      dataUKaryawan.addAll(userData);
      return dataUKaryawan;
    } catch (e) {
      print(e);
    }
    return dataUKaryawan;
  }
}
