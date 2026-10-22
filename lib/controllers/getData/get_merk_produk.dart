// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/merk.dart';
import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetMerkProdukAPI extends GetxController {
  final dataMerkProduk = List<Merk>.empty().obs;

  // Function Get Data Pesanan
  Future<List> getApi() async {
    // Paket offline: dari DB lokal, merk default 'All' dibuat otomatis
    if (paket.isOffline) {
      var merkData = await localStok.getMerk();
      if (merkData.isEmpty) {
        await localStok.insertMerk('All', 'All');
        merkData = await localStok.getMerk();
      }
      dataMerkProduk.assignAll(merkData.map((e) => Merk(
            id: e['_id'],
            code: e['code'],
            name: e['name'],
            userId: e['userId'],
          )));
      return dataMerkProduk;
    }

    try {
      var idOwner = token.read('role') != 'admin'
          ? token.read('parentId')
          : token.read('_id');
      print(idOwner);
      var response = await http.get(
        Uri.parse('$baseUrl/produk-merk/$idOwner/get-by-owner'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pesanan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataMerkProduk;
      }
      //

      if (dataMerkProduk.isNotEmpty) {
        dataMerkProduk.clear();
        dataMerkProduk.refresh();
      }

      var merkData = (data as Map<String, dynamic>)['data'];

      // apabila data success tetapi data kosong akan ditambahkan All pada awal data
      if (merkData.length == 0) {
        await postApiInsertMerkProduk.connectAPI(
          token.read('_id'),
          'All',
          'All',
        );
      }

      for (var e in merkData) {
        dataMerkProduk.add(Merk(
          id: e['_id'],
          code: e['code'],
          name: e['name'],
          userId: e['userId'],
        ));
      }

      return dataMerkProduk;
    } catch (e) {
      print(e);
    }
    return dataMerkProduk;
  }
}
