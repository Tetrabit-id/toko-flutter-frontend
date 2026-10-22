import 'package:tetrabit_toko_pos/components/filter_stok_kasir.dart';
import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/base_url.dart';
import '../../../routes/state_global.dart';
import 'components/body_orderan.dart';
import 'components/body_pembayaran.dart';

class KasirPage extends StatefulWidget {
  const KasirPage({Key? key}) : super(key: key);

  @override
  State<KasirPage> createState() => _KasirPageState();
}

class _KasirPageState extends State<KasirPage> {
  @override
  void initState() {
    super.initState();
    kasir.dataKasir;
    getApiPelanggan.dataPelangganById.clear();
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerKasirPage(querySize.size, context),
        body: Stack(
          fit: StackFit.expand,
          children: [
            BodyOrderan(size: querySize.size),
            BodyPembayaran(
              size: querySize.size,
              dataNmKry: token.read('name'),
              dataNmToko: token.read('store'),
            ),
          ],
        ),
      ),
    );
  }

  AppBar headerKasirPage(Size size, BuildContext context) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: const Text('Kasir',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
      toolbarHeight: 140,
      bottom: PreferredSize(
          preferredSize: Size(size.width, 25),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                          width: size.width,
                          height: 40,
                          child: const FilterStokKasirPage()),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                kasir.temp = num.parse(kasir.countC.text);
                                kasir.temp--;
                                if (num.parse(kasir.countC.text) <= 1) {
                                  kasir.countC =
                                      TextEditingController(text: '1');
                                } else {
                                  kasir.countC = TextEditingController(
                                      text: kasir.temp.toString());
                                }
                              });
                              kasir.updateTotalPembelian();
                            },
                            child: const SizedBox(
                              width: 35,
                              child: Text('-',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: AppColors.primaryColor)),
                            )),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: TextField(
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 3),
                              filled: true,
                              enabled: true,
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.borderColor)),
                            ),
                            controller: kasir.countC,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                kasir.temp = num.parse(kasir.countC.text);
                                kasir.temp++;

                                kasir.countC = TextEditingController(
                                    text: kasir.temp.toString());
                              });
                              kasir.updateTotalPembelian();
                            },
                            child: const SizedBox(
                              width: 35,
                              child: Text(
                                '+',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 35,
                                    color: AppColors.primaryColor),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                Obx(
                  () => buttonPrimary(
                    'Tambah',
                    kasir.checkBayar.value
                        ? AppColors.primaryColor
                        : Colors.grey,
                    Colors.white,
                    Colors.transparent,
                    Size(size.width, 25),
                    kasir.checkBayar.value
                        ? () {
                            kasir.addFilterDataStok(
                              kasir.filterC.text,
                              stok.dataStok.toList(),
                              kasir.filterC.text,
                            );
                            FocusScope.of(context).requestFocus(FocusNode());
                            kasir.controllerFieldC.clear();
                            kasir.filterC.clear();
                          }
                        : () {},
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          )),
    );
  }
}
