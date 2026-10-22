// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class InsertTransaksiAPI extends GetxController {
  Future<void> connectAPI(
    String userId,
    String cabangId,
    String noInv,
    String date,
    String? discountName,
    String? discountUnit,
    num? discountAmount,
    num subJumlahTransaksi,
    num jumlahPembayaran,
    num jumlahTransaksi,
    num kembalian,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/transaksi'),
        body: json.encode({
          'name': token.read('name'),
          'userId': userId,
          'noInvoice': noInv,
          'cabangId': cabangId,
          'discountName': discountName,
          'discountUnit': discountUnit,
          'discountAmount': discountAmount,
          'subJumlahTransaksi': subJumlahTransaksi,
          'date': date,
          'jumlahPembayaran': jumlahPembayaran,
          'jumlahTransaksi': jumlahTransaksi,
          'kembalian': kembalian,
        }),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );
      var data = jsonDecode(response.body);

      // Insert Transaksi Gagal
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );
        return;
      }

      // Insert Transaksi Success
      snackbarNotif.success('Success', 'Transaksi berhasil tersimpan');
      //
    } catch (e) {
      print(e);
    }
  }
}
