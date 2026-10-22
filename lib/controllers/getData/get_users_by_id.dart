// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetUsersByIdAPI extends GetxController {
  final dataUsers = List.empty().obs;

  // Function Get Data user
  Future<List> getApi(String userId) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data user
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataUsers;
      }
      //

      if (dataUsers.isNotEmpty) {
        dataUsers.clear();
        dataUsers.refresh();
      }

      var userData = (data as Map<String, dynamic>)['data'];
      dataUsers.addAll([userData]);

      return dataUsers;
    } catch (e) {
      print(e);
    }
    return dataUsers;
  }
}
