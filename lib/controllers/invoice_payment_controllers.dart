import 'package:tetrabit_toko_pos/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/invoice_popup.dart';
import '../routes/state_global.dart';

class AddInvoicePayment extends GetxController {
  final dataInvoice = List<InvoicePayment>.empty().obs;

  void laporanCard(int index, dataInvoice, size) async {
    getApiPesananByInv.dataPesanan.clear();
    payment.dataInvoice.clear();
    await getApiPesananByInv.getApi(dataInvoice[index]['noInvoice']);

    var list = dataInvoice[index];

    payment.addPopUpPayment(
      list['name'] ?? '',
      list['noInvoice'],
      list['date'],
      list['discountUnit'] ?? 'Tidak ada',
      list['discountName'] ?? '',
      list['discountAmount'] ?? 0,
      list['subJumlahTransaksi'],
      list['jumlahTransaksi'],
      list['jumlahPembayaran'],
      list['kembalian'],
      getApiPesananByInv.dataPesanan,
    );

    Get.defaultDialog(
        title: '',
        titlePadding: const EdgeInsets.only(top: 0),
        content: PopUpInvoice(size: size));
  }

  void addPopUpPayment(
    String nmKasir,
    String noInv,
    String date,
    String discountUnit,
    String discountName,
    int discountAmount,
    int subJumlahTransaksi,
    int amount,
    int bayar,
    int kembalian,
    List idKasir,
  ) {
    dataInvoice.add(InvoicePayment(
      namaKasir: nmKasir,
      noInvoice: noInv,
      discountUnit: discountUnit,
      discountName: discountName,
      discountAmount: discountAmount,
      subJumlahTransaksi: subJumlahTransaksi,
      date: date,
      amountInvoice: amount,
      bayar: bayar,
      kembalian: kembalian,
      idDataKasir: idKasir,
    ));
  }
}
