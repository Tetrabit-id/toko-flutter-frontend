// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetPesananByInvAPI extends GetxController {
  final dataPesanan = List.empty().obs;

  // Function Get Data Pesanan
  Future<List> getApi(String noInv) async {
    var invBase64 = base64Url.encode(utf8.encode(noInv));
    try {
      var response = await http.get(
        Uri.parse(
            '$baseUrl/pesanan/${token.read('_id')}/get-by-owner/$invBase64/invoice'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pesanan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataPesanan;
      }
      //

      if (dataPesanan.isNotEmpty) {
        dataPesanan.clear();
        dataPesanan.clear();
      }

      var pesananData = (data as Map<String, dynamic>)['data'];
      dataPesanan.addAll([pesananData]);

      return dataPesanan;
    } catch (e) {
      print(e);
    }
    return dataPesanan;
  }
}
