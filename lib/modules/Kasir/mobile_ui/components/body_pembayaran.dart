import 'package:tetrabit_toko_pos/components/add_diskon_popup.dart';
import 'package:tetrabit_toko_pos/components/select_member_kasir.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constructors/text_field_rounded.dart';
import '../../../../routes/state_global.dart';
import '../../../../style/styles.dart';

class BodyPembayaran extends StatefulWidget {
  const BodyPembayaran({
    super.key,
    required this.size,
    required this.dataNmKry,
    required this.dataNmToko,
  });

  final Size size;
  final String dataNmKry;
  final String dataNmToko;

  @override
  State<BodyPembayaran> createState() => _BodyPembayaranState();
}

class _BodyPembayaranState extends State<BodyPembayaran> {
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
    return SizedBox.expand(
      child: DraggableScrollableSheet(
          initialChildSize: (widget.size.height / 1000) * 0.15,
          snap: true,
          snapSizes: [(widget.size.height / 1000) * 0.15, 0.98],
          minChildSize: (widget.size.height / 1000) * 0.15,
          maxChildSize: 0.98,
          builder: (BuildContext context, scroll) {
            return Container(
              padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: ListView(
                controller: scroll,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.size.width / 2.5),
                    child: Container(
                      height: 2.5,
                      decoration: const BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  const SizedBox(height: 22),
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
                  const SizedBox(height: 15),
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
                      StreamBuilder(
                        stream: kasir.dataKasir.stream,
                        builder: (context, snapshot) {
                          return Expanded(
                              flex: 30,
                              child: Obx(
                                () => ElevatedButton.icon(
                                  label: const Text(
                                    'Print',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'Lato'),
                                  ),
                                  icon: const Icon(Icons.print_outlined),
                                  onPressed: kasir.open.value != true
                                      ? null
                                      : () {
                                          printer.printDataKasir(
                                            kasir.dataKasir,
                                            widget.dataNmKry,
                                            widget.dataNmToko,
                                            kasir,
                                          );
                                          printer.printer.isConnected
                                              .then((isConneted) {
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
                                          : AppColors.secondaryColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      )),
                                ),
                              ));
                        },
                      ),
                      Expanded(
                        flex: 70,
                        child: SizedBox(
                          height: 50,
                          child: Obx(
                            () => GestureDetector(
                              onTap: () => saveTransaksi(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.save_as,
                                    color: kasir.open.value != true
                                        ? Colors.grey
                                        : Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: kasir.open.value != true
                                          ? Colors.grey
                                          : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            );
          }),
    );
  }

  Column membership() {
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
              onPressed: pelanggan.foundPelangganId.isTrue
                  ? () {
                      getApiPelanggan.getByIdApi(pelanggan.filterC.text);
                      FocusScope.of(context).requestFocus(FocusNode());
                      pelanggan.filterC.clear();
                      pelanggan.controllerFieldC.clear();
                      pelanggan.foundPelangganId.value = false;
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(widget.size.width, 38),
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
                Size(widget.size.width, 20),
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
                            fixedSize: Size(widget.size.width, 42),
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
                width: widget.size.width / 4,
                height: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('atau'),
            ),
            Container(
                color: const Color.fromARGB(255, 212, 212, 212),
                width: widget.size.width / 4,
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
                          onPressed: paket.canPaymentGateway &&
                                  kasbon.kasbonActive.isFalse &&
                                  kasir.totalPembelian > 0
                              ? () => kasir.bayarOnline()
                              : null,
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size((widget.size.width / 2) - 24, 38),
                              backgroundColor: paket.canPaymentGateway &&
                                      kasir.checkBayar.value &&
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
                            fixedSize: Size((widget.size.width / 2) - 24, 38),
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
    return Obx(
      () => kasbon.kasbonActive.isTrue
          ? Container(
              width: widget.size.width,
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
