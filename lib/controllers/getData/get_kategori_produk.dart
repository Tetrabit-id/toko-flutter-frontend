// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:tetrabit_toko_pos/models/kategori.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/base_url.dart';
import '../../routes/state_global.dart';

class GetKategoriProdukAPI extends GetxController {
  final dataKategoriProduk = List<Kategori>.empty().obs;

  // Function Get Data Pesanan
  Future<List> getApi() async {
    // Paket offline: dari DB lokal, kategori default 'All' dibuat otomatis
    if (paket.isOffline) {
      var kategoriData = await localStok.getKategori();
      if (kategoriData.isEmpty) {
        await localStok.insertKategori('All', 'All');
        kategoriData = await localStok.getKategori();
      }
      dataKategoriProduk.assignAll(kategoriData.map((e) => Kategori(
            id: e['_id'],
            code: e['code'],
            name: e['name'],
            userId: e['userId'],
            image: e['image'],
          )));
      return dataKategoriProduk;
    }

    try {
      var idOwner = token.read('role') != 'admin'
          ? token.read('parentId')
          : token.read('_id');
      var response = await http.get(
        Uri.parse('$baseUrl/produk-kategori/$idOwner/get-by-owner'),
        headers: {'Authorization': 'Bearer ${token.read('token')}'},
      );

      var data = jsonDecode(response.body);

      // Jika gagal get data pesanan
      if (response.statusCode != 200) {
        snackbarNotif.unsuccess(
          'Unsuccess ${response.statusCode}',
          '${(data['message']).toString().capitalizeFirst}',
        );

        return dataKategoriProduk;
      }
      //

      if (dataKategoriProduk.isNotEmpty) {
        dataKategoriProduk.clear();
        dataKategoriProduk.refresh();
      }

      var kategoriData = (data as Map<String, dynamic>)['data'];

      // apabila data success tetapi data kosong akan ditambahkan All pada awal data
      if (kategoriData.length == 0) {
        await postApiInsertKategoriProduk.connectAPI(
          token.read('_id'),
          'All',
          'All',
        );
      }

      for (var e in kategoriData) {
        dataKategoriProduk.add(Kategori(
          id: e['_id'],
          code: e['code'],
          name: e['name'],
          userId: e['userId'],
          image: e['image'],
        ));
      }

      return dataKategoriProduk;
    } catch (e) {
      print(e);
    }
    return dataKategoriProduk;
  }
}
