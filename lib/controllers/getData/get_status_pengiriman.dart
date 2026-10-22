// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetStatusPengirimanAPI extends GetxController {
  final dataStatusPengiriman = List.empty().obs;

  // Function Get Data Stok
  Future<List> getAPI(String? id) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/pengiriman/$id/get-by-owner/all/cabang'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data stok
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return dataStatusPengiriman;
      }
      //

      if (dataStatusPengiriman.isNotEmpty) {
        dataStatusPengiriman.clear();
        dataStatusPengiriman.refresh();
      }

      var statusPengirimanData = (data as Map<String, dynamic>)['data'];
      dataStatusPengiriman.addAll(statusPengirimanData);
      return dataStatusPengiriman;
    } catch (e) {
      print(e);
    }
    return dataStatusPengiriman;
  }
}
