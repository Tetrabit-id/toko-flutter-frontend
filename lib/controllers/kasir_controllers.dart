import 'dart:async';

import 'package:diatera_pos/models/kasir.dart';
import 'package:diatera_pos/routes/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/state_global.dart';

class AddKasir extends GetxController {
  var dataKasir = List<Kasir>.empty().obs;
  var noInv = '';
  var namaDiskon = '';
  var falseKeyword = true;

  RxBool open = false.obs;
  RxBool checkBayar = true.obs;
  RxBool checked = false.obs;
  RxBool discountChecked = false.obs;
  RxBool discountByRp = true.obs;
  num temp = 0;
  num totalPembelian = 0;
  num discount = 0;
  num kembalian = 0;

  late TextEditingController filterC = TextEditingController();
  late TextEditingController controllerFieldC = TextEditingController();
  late TextEditingController bayarC = TextEditingController();
  late TextEditingController countC = TextEditingController(text: '1');
  late TextEditingController diskonC = TextEditingController();
  late TextEditingController namaDiskonC = TextEditingController();

  num getCount(String kodeBrg) {
    num count = 0;
    for (var element in dataKasir) {
      if (element.kodeBarang == kodeBrg) {
        count += element.qtyPembelian;
      }
    }
    return count;
  }

  void addPesanan(
    String? userId,
    String? cabangId,
    String? stokId,
    String? produkId,
    String? noInv,
    String? kodeBarang,
    String? namaBarang,
    String? fotoBarang,
    int qtyStok,
    int hargaBarangStok,
    int qtyPembelian,
    num totalHarga,
  ) {
    dataKasir.add(Kasir(
      id: DateTime.now().toString(),
      userId: userId,
      cabangId: cabangId,
      stokId: stokId,
      produkId: produkId,
      noInv: noInv,
      kodeBarang: kodeBarang,
      namaBarang: namaBarang,
      qtyStok: qtyStok,
      fotoBarang: fotoBarang,
      hargaBarangStok: hargaBarangStok,
      qtyPembelian: qtyPembelian,
      totalHarga: totalHarga,
    ));

    updateTotalPembelian();
    countC.text = '1';

    try {} catch (_) {
      snackbarNotif.unsuccess(
        'Unsuccess',
        'Mohon cek kembali data pesananmu',
      );
    }
  }

  void addFilterDataStok(String keyword, List dataStok, String value) {
    List kodeBrg = [];
    List namaBrg = [];
    List qtyBrg = [];
    List hargaBrg = [];
    List produkId = [];
    List stokId = [];
    List cabangId = [];
    List fotoBrg = [];

    stokId = dataStok.map((e) => e['_id']).toList();
    produkId = dataStok.map((e) => e['produkId']).toList();
    cabangId = dataStok.map((e) => e['cabangId']).toList();
    kodeBrg = dataStok.map((e) => e['code']).toList();
    namaBrg = dataStok.map((e) => e['name']).toList();
    hargaBrg = dataStok.map((e) => e['harga']).toList();
    qtyBrg = dataStok.map((e) => e['qty']).toList();
    fotoBrg = dataStok.map((e) => e['produk']['file']).toList();

    for (var i = 0; i < dataStok.length; i++) {
      if (keyword.toLowerCase() == (namaBrg[i].toString()).toLowerCase() ||
          value == kodeBrg[i].toString()) {
        falseKeyword = false;

        // Melihat Stok apakah tersedia
        // int stok = int.parse(dataStok[i].qty!);
        // num qtyPesanan =
        //     int.parse(countC.text) + getCount(dataStok[i].kodeBarang!);

        // if (stok < qtyPesanan) {
        //   Get.snackbar(
        //     'Jumlah Stok Kurang',
        //     'Jumlah stokmu hanya tersisa ${dataStok[i].qty}',
        //     colorText: Colors.white,
        //     backgroundColor: Colors.redAccent,
        //     margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
        //     isDismissible: true,
        //     dismissDirection: DismissDirection.horizontal,
        //   );
        //   return;
        // }

        num totalHarga = hargaBrg[i] * num.parse(countC.text);

        for (var j = 0; j < dataKasir.length; j++) {
          var namaBrg = dataKasir.map((element) => element.namaBarang).toList();
          var kodeBrg = dataKasir.map((element) => element.kodeBarang).toList();
          if (dataKasir.isNotEmpty &&
                  keyword.toLowerCase() ==
                      namaBrg[j].toString().toLowerCase() ||
              value == kodeBrg[j].toString()) {
            dataKasir[j].qtyPembelian =
                dataKasir[j].qtyPembelian + int.parse(countC.text);
            num record = 0;
            num recordHargaNew = 0;
            record = dataKasir[j].totalHarga;
            recordHargaNew = totalHarga;
            dataKasir[j].totalHarga = record + recordHargaNew;

            updateTotalPembelian();
            countC.text = '1';

            dataKasir.refresh();

            return;
          }
        }

        addPesanan(
          token.read('_id'),
          cabangId[i],
          stokId[i],
          produkId[i],
          '',
          kodeBrg[i],
          namaBrg[i],
          fotoBrg[i],
          qtyBrg[i],
          hargaBrg[i],
          int.parse(countC.text),
          totalHarga,
        );
      }

      if (checked.value == true || keyword.isEmpty) {
        snackbarNotif.unsuccess(
          'Keyword tidak sesuai',
          'Harap masukkan keyword sesuai nama barang / kode barang di stokmu',
        );

        return;
      }
    }
  }

  void diskon() {
    if (kasir.diskonC.text == '' || kasir.namaDiskonC.text == '') {
      snackbarNotif.unsuccess('Data Kosong', 'Mohon lengkapi form diskon');
      return;
    }

    if (!kasir.discountByRp.value) {
      discount = kasir.totalPembelian * (num.parse(diskonC.text) / 100);
    } else {
      discount = num.parse(diskonC.text.substring(4).replaceAll(',', ''));
    }

    if (discount > kasir.totalPembelian) {
      snackbarNotif.unsuccess(
          'Unsuccess Discount', 'Harga diskon melebihi harga order');
      diskonC.clear();
      return;
    }

    kasir.totalPembelian = kasir.totalPembelian - discount;
    namaDiskon = namaDiskonC.text;
    kasir.dataKasir.refresh();
    discountChecked.value = true;
    Get.back();

    namaDiskonC.clear();

    return;
  }

  void bayar() {
    if (kasir.bayarC.text != '') {
      String bayar = (kasir.bayarC.text).replaceAll(',', '').substring(4);

      var idOwner = token.read('role') != 'admin'
          ? token.read('parentId')
          : token.read('_id');
      postApiInsertPesanan.connectAPI(kasir.dataKasir.toList(), idOwner);

      kasir.kembalian = num.parse(bayar) - kasir.totalPembelian;
      kasir.dataKasir.refresh();
      Timer(
          const Duration(seconds: 2),
          () => {
                kasir.checked.value = false,
                kasir.open.value = true,
                kasir.checkBayar.value = false,
              });
      // refresh stok
      stok.foundStok.clear();
      getApiStok.getAPI(token.read('_id'), token.read('cabangId'));
      stok.foundStok = getApiStok.dataStok;
      // end
    } else {
      snackbarNotif.unsuccess('Pembayaran Kosong', 'Mohon isi form pembayaran');
    }
  }

  void transaksi() async {
    var idOwner = token.read('role') != 'admin'
        ? token.read('parentId')
        : token.read('_id');
    await postApiInsertTransaksi.connectAPI(
      idOwner,
      token.read('cabangId'),
      kasir.noInv,
      DateTime.now().toString().substring(0, 10),
      kasir.namaDiskon,
      kasir.discountChecked.isTrue
          ? kasir.discountByRp.isTrue
              ? 'rp'
              : '${kasir.diskonC.text}%'
          : 'Tidak ada',
      kasir.discount,
      kasir.discountChecked.isTrue
          ? kasir.totalPembelian + kasir.discount
          : kasir.totalPembelian,
      kasbon.kasbonActive.isTrue
          ? 0
          : num.parse(kasir.bayarC.text.substring(4).replaceAll(',', '')),
      kasir.totalPembelian,
      kasir.kembalian,
    );

    var member = getApiPelanggan.dataPelangganById;
    if (kasbon.kasbonActive.isTrue && member.isNotEmpty) {
      var data = await getApiTransaksi.getApi();
      postApiInsertKasbon.connectAPI(
          idOwner,
          token.read('cabangId'),
          member[0]['_id'],
          member[0]['memberId'],
          data.last['_id'],
          '',
          DateTime.now().toString().substring(0, 10));
    }

    if (member.isNotEmpty) {
      putApiUpdatePoint.connectAPI(member[0]['_id'], member[0]['poin'] + 100);
    }

    dataKasir.clear();
    member.clear();
    totalPembelian = 0;
    bayarC.clear();
    kembalian = 0;
    noInv = '';
    Timer(const Duration(seconds: 1),
        () => {kasir.open.value = false, kasir.checkBayar.value = true});
  }

  void updateTotalPembelian() {
    totalPembelian = 0;
    for (var i = 0; i < dataKasir.length; i++) {
      num record = dataKasir[i].totalHarga;
      totalPembelian = totalPembelian + record;
      dataKasir.refresh();
    }
  }

  Future<bool> delete(String id) async {
    bool deleted = false;
    await Get.defaultDialog(
      title: 'Delete Data',
      middleText: "Apakah kamu yakin menghapus data ini secara permanen?",
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textConfirm: "Delete",
      buttonColor: Colors.white,
      confirmTextColor: Colors.red,
      cancelTextColor: Colors.black45,
      onConfirm: () {
        dataKasir.removeWhere((element) => element.id == id);
        updateTotalPembelian();
        deleted = true;
        Get.back();
      },
      textCancel: "Cancel",
    );
    return deleted;
  }

  @override
  void onInit() {
    checked.value = false;
    falseKeyword = true;
    temp = 0;
    totalPembelian = 0;
    kembalian = 0;
    filterC = TextEditingController();
    bayarC = TextEditingController();
    countC = TextEditingController(text: '1');
    super.onInit();
  }

  @override
  void onClose() {
    filterC.dispose();
    bayarC.dispose();
    countC.dispose();
    super.onClose();
  }
}
