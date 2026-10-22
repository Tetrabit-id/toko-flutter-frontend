import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:get/get.dart';

import '../../../components/stok_card.dart';
import '../../../constructors/button_primary.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_field_rounded.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/base_url.dart';
import '../../../routes/state_global.dart';

class StokPageforTablet extends StatefulWidget {
  const StokPageforTablet({Key? key}) : super(key: key);

  @override
  State<StokPageforTablet> createState() => _StokPageforTabletState();
}

class _StokPageforTabletState extends State<StokPageforTablet> {
  String? scannerQr = '';

  @override
  void initState() {
    super.initState();

    getApiStok.getAPI(token.read('_id'), token.read('cabangId'));
    stok.foundStok = getApiStok.dataStok;
  }

  void filterStok(String keyword) {
    List resultFilter = [];
    if (keyword.isEmpty) {
      resultFilter = getApiStok.dataStok.toList();
    } else {
      var results = getApiStok.dataStok.toList();

      resultFilter = results
          .where((element) =>
              element.namaBarang!
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              element.kodeBarang!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      stok.foundStok = resultFilter.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    var namaBarang = stok.nmBrgC;
    var kodeBarang = stok.kodeBrgC;
    var qty = stok.qtyBrgC;
    var satuan = stok.satuanBrgC;
    var harga = stok.hrgBrgC;
    Size size = MediaQuery.of(context).size;

    Future<void> scanQR() async {
      scannerQr = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      String data = '';
      setState(() {
        data = scannerQr!;
        if (data == '-1') {
          data = '';
        }
      });
      kodeBarang.text = data;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Stok',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: textFieldDefaultIcon(
                              'Cari nama barang, kode barang',
                              const Size(50, 20),
                              false,
                              const Icon(Icons.search),
                              (value) => filterStok(value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<Object>(
                        stream: stok.foundStok.stream,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 20, left: 20),
                            child: stok.foundStok.isEmpty
                                ? SizedBox(
                                    height: size.height / 0.8,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppSvg.notFoundStokSvg,
                                          const SizedBox(height: 25),
                                          headerNotFound('Stok kosong'),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ))
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: stok.foundStok.length,
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                                color: Colors.grey, height: 25),
                                        itemBuilder: (context, index) =>
                                            FilterStokCard(
                                                index: index,
                                                role: token.read('role'))),
                                  ),
                          );
                        }),
                  ],
                ),
              ),
              Expanded(
                flex: 40,
                child: Container(
                  color: AppColors.bgGrey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSvg.stokSvg,
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => scanQR(),
                            child: const SizedBox(
                              width: 40,
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 60,
                            child: textFieldRounded(
                              'Kode Barang',
                              kodeBarang,
                              false,
                              TextInputType.text,
                              false,
                              size,
                            ),
                          ),
                        ],
                      ),
                      textFieldRounded(
                        'Nama Barang',
                        namaBarang,
                        false,
                        TextInputType.text,
                        false,
                        size,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 20,
                            child: textFieldRoundedwithHint(
                              'Qty',
                              qty,
                              false,
                              TextInputType.number,
                              '0',
                              TextAlign.center,
                              size,
                              4,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 60,
                            child: textFieldRoundedwithHint(
                              'Satuan',
                              satuan,
                              false,
                              TextInputType.name,
                              'satuan barang',
                              TextAlign.start,
                              size,
                              5,
                            ),
                          )
                        ],
                      ),
                      textFieldRoundedCurrentwithHint(
                        'Harga per satuan',
                        harga,
                        false,
                        TextInputType.number,
                        'Rp.',
                        TextAlign.start,
                        size,
                      ),
                      const SizedBox(height: 30),
                      buttonPrimary(
                        'Tambah',
                        kodeBarang.text != '' &&
                                namaBarang.text != '' &&
                                qty.text != '' &&
                                satuan.text != '' &&
                                harga.text != ''
                            ? AppColors.primaryColor
                            : Colors.grey,
                        Colors.white,
                        Colors.transparent,
                        Size(size.width - 140, size.height / 20),
                        () {
                          if (kodeBarang.text != '' &&
                              namaBarang.text != '' &&
                              qty.text != '' &&
                              satuan.text != '' &&
                              harga.text != '') {
                            // var valid = stok.validatorKodeBrg(
                            //     kodeBarang.text, namaBarang.text);

                            // (!valid)
                            //     ? postApiInsertProduk.connectAPI(
                            //         token.read('_id'),
                            //         token.read('cabangId'),
                            //         kodeBarang.text,
                            //         namaBarang.text.capitalizeFirst,
                            //         int.parse(qty.text),
                            //         satuan.text,
                            //         int.parse(
                            //           harga.text
                            //               .replaceAll(',', '')
                            //               .substring(4),
                            //         ),
                            //       )
                            // stok.addStok(
                            //     kodeBarang.text,
                            //     namaBarang.text.capitalizeFirst,
                            //     qty.text,
                            //     satuan.text,
                            //     harga.text,
                            //   )
                            // : Get.snackbar(
                            //     'Error Data',
                            //     '${stok.validasiText} sudah ada. Masukkan ${stok.validasiText} baru',
                            //     colorText: Colors.white,
                            //     backgroundColor: Colors.redAccent,
                            //     margin: const EdgeInsets.only(
                            //         top: 10, right: 10, left: 10),
                            //     isDismissible: true,
                            //     dismissDirection:
                            //         DismissDirection.horizontal,
                            //   );
                          } else {
                            Get.defaultDialog(
                              titlePadding: const EdgeInsets.only(top: 15),
                              buttonColor: AppColors.primaryColor,
                              confirmTextColor: Colors.white,
                              title: "Data Kosong",
                              middleText: "Mohon lakukan Periksa Data kembali",
                              textConfirm: 'OK',
                              onConfirm: () => Get.back(),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
