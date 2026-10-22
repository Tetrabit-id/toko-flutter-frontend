import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tetrabit_toko_pos/components/filter_stok_kasir.dart';
import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';

import '../../../components/add_diskon_popup.dart';
import '../../../components/select_member_kasir.dart';
import '../../../constructors/text_field_rounded.dart';
import '../../../routes/state_global.dart';
import 'components/body_orderan.dart';

class KasirPageforTablet extends StatefulWidget {
  const KasirPageforTablet({Key? key}) : super(key: key);

  @override
  State<KasirPageforTablet> createState() => _KasirPageforTabletState();
}

class _KasirPageforTabletState extends State<KasirPageforTablet> {
  String dataNmKry = '';
  String dataNmToko = '';

  @override
  void initState() {
    super.initState();
    kasir.dataKasir;
  }

  void addDiscount() async {
    if (kasir.totalPembelian <= 0) {
      return;
    }

    kasir.diskonC.clear();
    kasir.namaDiskonC.clear();
    kasir.discountByRp.value = true;

    Get.defaultDialog(
      title: 'Tambah Diskon',
      titlePadding: const EdgeInsets.only(top: 20),
      content: const PopUpDiskon(),
    );
  }

  void deleteDiskon() {
    setState(() {
      kasir.discount = 0;
      kasir.namaDiskon = '';
      kasir.discountChecked.value = false;
    });

    kasir.updateTotalPembelian();
  }

  void saveTransaksi() {
    kasir.transaksi();
    deleteDiskon();
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                  flex: 65,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          children: [
                            const Text('Kasir',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      width: querySize.size.width,
                                      height: 40,
                                      child: const FilterStokKasirPage()),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            kasir.temp =
                                                num.parse(kasir.countC.text);
                                            kasir.temp--;
                                            if (num.parse(kasir.countC.text) <=
                                                1) {
                                              kasir.countC =
                                                  TextEditingController(
                                                      text: '1');
                                            } else {
                                              kasir.countC =
                                                  TextEditingController(
                                                      text: kasir.temp
                                                          .toString());
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
                                                  color:
                                                      AppColors.primaryColor)),
                                        )),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 3),
                                          filled: true,
                                          enabled: true,
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      AppColors.borderColor)),
                                        ),
                                        controller: kasir.countC,
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            kasir.temp =
                                                num.parse(kasir.countC.text);
                                            kasir.temp++;

                                            kasir.countC =
                                                TextEditingController(
                                                    text:
                                                        kasir.temp.toString());
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
                            buttonPrimary(
                                'Tambah',
                                AppColors.primaryColor,
                                Colors.white,
                                Colors.transparent,
                                Size(querySize.size.width, 25), () {
                              kasir.controllerFieldC.clear();
                              kasir.addFilterDataStok(
                                kasir.filterC.text,
                                stok.dataStok.toList(),
                                kasir.filterC.text,
                              );
                              FocusScope.of(context).requestFocus(FocusNode());
                            }),
                          ],
                        ),
                      ),
                      BodyOrderan(size: querySize.size),
                    ],
                  )),
              Expanded(
                flex: 40,
                child: bodyPembayaran(querySize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding bodyPembayaran(MediaQueryData querySize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        height: querySize.size.height / 1.1,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Harga Order',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                StreamBuilder<Object>(
                    stream: kasir.dataKasir.stream,
                    builder: (context, snapshot) {
                      return Text(current.format(kasir.totalPembelian),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold));
                    }),
              ],
            ),
            const SizedBox(height: 10),
            discount(),
            line(10),
            paymentMethod(),
            line(10),
            membership(),
            line(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kembalian',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                StreamBuilder<Object>(
                    stream: kasir.dataKasir.stream,
                    builder: (context, snapshot) {
                      return Text(current.format(kasir.kembalian),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold));
                    }),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    flex: 40,
                    child: ElevatedButton.icon(
                      label: const Text(
                        'Print',
                        style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                      ),
                      icon: const Icon(Icons.print_outlined),
                      onPressed: kasir.open.value != true
                          ? null
                          : () {
                              printer.printDataKasir(
                                kasir.dataKasir,
                                dataNmKry,
                                dataNmToko,
                                kasir,
                              );
                              printer.printer.isConnected.then((isConneted) {
                                if (isConneted != true) {
                                  return;
                                }
                                kasir.transaksi();
                              });
                            },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(130, 0),
                          backgroundColor: kasir.open.value != true
                              ? Colors.grey
                              : AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                    )),
                Expanded(
                  flex: 70,
                  child: SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTap: kasir.open.value != true
                          ? null
                          : () => kasir.transaksi(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.save_as,
                              color: kasir.open.value != true
                                  ? Colors.grey
                                  : Colors.black87,
                              size: 20),
                          const SizedBox(width: 5),
                          Text('Simpan',
                              style: TextStyle(
                                fontSize: 18,
                                color: kasir.open.value != true
                                    ? Colors.grey
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column membership() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            kasbon.kasbonActive.isFalse
                ? 'Pelanggan (opsional)'
                : 'Pelanggan (wajib)',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        const SelectMemberKasirPage(),
        const SizedBox(height: 5),
        Obx(
          () => ElevatedButton(
              onPressed: getApiPelanggan.dataPelangganById.isEmpty
                  ? () {
                      getApiPelanggan.getByIdApi(pelanggan.filterC.text);
                      FocusScope.of(context).requestFocus(FocusNode());
                      pelanggan.filterC.clear();
                      pelanggan.controllerFieldC.clear();
                      pelanggan.foundPelangganId.value = false;
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(size.width, 38),
                backgroundColor: pelanggan.foundPelangganId.isFalse
                    ? Colors.grey
                    : AppColors.primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              child: const Text('Pilih Member')),
        ),
        Obx(
          () => getApiPelanggan.dataPelangganById.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getApiPelanggan.dataPelangganById[0]['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              getApiPelanggan.dataPelangganById[0]['memberId'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ]),
                      GestureDetector(
                        onTap: () => getApiPelanggan.dataPelangganById.clear(),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        )
      ],
    );
  }

  Padding line(double verticalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Container(
          height: 1,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 212, 212, 212),
          )),
    );
  }

  Row discount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diskon',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 1),
            kasir.discount == 0
                ? const Text(
                    'Tidak ada diskon',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        color: AppColors.primaryColor),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.format(kasir.discount),
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Lato',
                                color: AppColors.primaryColor),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            kasir.namaDiskon,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () => deleteDiskon(),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ))
                    ],
                  )
          ],
        ),
        const SizedBox(width: 10),
        ElevatedButton(
            onPressed:
                !kasir.discountChecked.value ? () => addDiscount() : null,
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 0),
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: !kasir.discountChecked.value
                          ? AppColors.primaryColor
                          : Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_add_sharp,
                    size: 18,
                    color: !kasir.discountChecked.value
                        ? AppColors.primaryColor
                        : Colors.grey),
                Text(
                  'Diskon',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lato',
                      color: !kasir.discountChecked.value
                          ? AppColors.primaryColor
                          : Colors.grey),
                )
              ],
            )),
      ],
    );
  }

  Column paymentMethod() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 70,
              child: textFieldRoundedCurrentwithHint(
                'Bayar',
                kasir.bayarC,
                false,
                TextInputType.number,
                'Rp.',
                TextAlign.start,
                Size(size.width, 20),
              ),
            ),
            const SizedBox(width: 10),
            StreamBuilder<Object>(
                stream: kasir.dataKasir.stream,
                builder: (context, snapshot) {
                  return Expanded(
                    flex: 30,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: kasir.checkBayar.value &&
                                kasbon.kasbonActive.isFalse &&
                                kasir.totalPembelian > 0
                            ? () => kasir.bayar()
                            : null,
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(size.width, 42),
                            shadowColor: Colors.transparent,
                            backgroundColor: kasir.checkBayar.value &&
                                    kasbon.kasbonActive.isFalse &&
                                    kasir.totalPembelian > 0
                                ? AppColors.primaryColor
                                : Colors.grey,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            )),
                        child: Obx(
                          () => !kasir.checked.value
                              ? const Text(
                                  'Tunai',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: 'Lato'),
                                )
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                color: const Color.fromARGB(255, 212, 212, 212),
                width: size.width / 8.1,
                height: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('atau'),
            ),
            Container(
                color: const Color.fromARGB(255, 212, 212, 212),
                width: size.width / 8.1,
                height: 1),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Column(
              children: [
                StreamBuilder<Object>(
                  stream: kasir.dataKasir.stream,
                  builder: (context, snapshot) {
                    return Obx(
                      () => ElevatedButton(
                          // Paket offline: tunai saja, tanpa payment gateway
                          // Nilai Rx dibaca duluan: Obx error jika tidak ada Rx yang dibaca
                          onPressed: kasbon.kasbonActive.isFalse &&
                                  paket.canPaymentGateway &&
                                  kasir.totalPembelian > 0
                              ? () => kasir.bayarOnline()
                              : null,
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size((size.width / 6) - 20, 38),
                              backgroundColor: kasir.checkBayar.value &&
                                      paket.canPaymentGateway &&
                                      kasir.totalPembelian > 0
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              )),
                          child: const Text('Non Tunai')),
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              children: [
                StreamBuilder<Object>(
                  stream: kasir.dataKasir.stream,
                  builder: (context, snapshot) {
                    return Obx(() => ElevatedButton(
                        onPressed: () {
                          if (kasir.totalPembelian > 0) {
                            kasbon.kasbonActive.value = true;
                            kasir.open.value = true;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size((size.width / 6) - 20, 38),
                            shadowColor: Colors.transparent,
                            backgroundColor: kasir.checkBayar.value &&
                                    kasir.totalPembelian > 0
                                ? AppColors.primaryColor
                                : Colors.grey,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            )),
                        child: const Text('Kasbon')));
                  },
                )
              ],
            )
          ],
        ),
        cardActiveKasbon()
      ],
    );
  }

  Obx cardActiveKasbon() {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => kasbon.kasbonActive.isTrue
          ? Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '✓ Kasbon Aktif',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                  GestureDetector(
                      onTap: () {
                        kasbon.kasbonActive.value = false;
                        kasir.open.value = true;
                      },
                      child: const Icon(Icons.close_rounded, size: 18))
                ],
              ))
          : const SizedBox(),
    );
  }
}
