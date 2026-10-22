import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/state_global.dart';
import '../style/styles.dart';
import 'produk_image.dart';

class CardPemesananKasirPage extends StatefulWidget {
  const CardPemesananKasirPage({Key? key, this.index = 0}) : super(key: key);

  final int index;

  @override
  State<CardPemesananKasirPage> createState() => _CardPemesananKasirPageState();
}

class _CardPemesananKasirPageState extends State<CardPemesananKasirPage> {
  void decrement(num totalHarga, num hargaSatuan) {
    setState(() {
      kasir.temp =
          num.parse(kasir.dataKasir[widget.index].qtyPembelian.toString());
      kasir.temp--;
      if (num.parse(kasir.dataKasir[widget.index].qtyPembelian.toString()) <=
          1) {
        kasir.dataKasir[widget.index].qtyPembelian = 1;
      } else {
        kasir.dataKasir[widget.index].qtyPembelian = kasir.temp;
        totalHarga = totalHarga - (hargaSatuan);
        kasir.dataKasir[widget.index].totalHarga = totalHarga;

        kasir.updateTotalPembelian();
      }
    });
  }

  void increment(num totalHarga, num hargaSatuan) {
    setState(() {
      // int index = 0;
      // for (var i = 0; i < stok.dataStok.length; i++) {
      //   if (stok.dataStok[i]['code'] ==
      //       kasir.dataKasir[widget.index].kodeBarang) {
      //     setState(() {
      //       index = i;
      //     });
      //   }
      // }
      // int stokData = stok.dataStok[index]['qty'];
      // num qtyPesanan = kasir.getCount(stok.dataStok[index]['code']) +
      //     kasir.getCount(
      //         (kasir.dataKasir[widget.index].qtyPembelian).toString());
      // if (stokData <= qtyPesanan) {
      //   Get.snackbar(
      //     'Jumlah Stok Kurang',
      //     'Jumlah stokmu hanya tersisa ${stok.dataStok[index]['qty']}',
      //     colorText: Colors.white,
      //     backgroundColor: Colors.redAccent,
      //     margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      //     isDismissible: true,
      //     dismissDirection: DismissDirection.horizontal,
      //   );
      //   return;
      // }

      kasir.temp =
          num.parse(kasir.dataKasir[widget.index].qtyPembelian.toString());
      kasir.temp++;
      kasir.dataKasir[widget.index].qtyPembelian = kasir.temp;

      totalHarga = totalHarga + (hargaSatuan);
      kasir.dataKasir[widget.index].totalHarga = totalHarga;

      kasir.updateTotalPembelian();
    });
  }

  @override
  Padding build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    num hargaSatuan = kasir.dataKasir[widget.index].hargaBarangStok;
    num totalHarga = kasir.dataKasir[widget.index].totalHarga;

    var fotoBarang = kasir.dataKasir[widget.index].fotoBarang;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Container(
                width: size.width,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    border: Border.all(color: AppColors.borderColor)),
                child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: produkImage(fotoBarang))),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${kasir.dataKasir[widget.index].namaBarang}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(
                                '#${kasir.dataKasir[widget.index].kodeBarang} @ ${current.format(kasir.dataKasir[widget.index].hargaBarangStok)}'),
                          ],
                        )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => GestureDetector(
                                  onTap: kasir.checkBayar.value
                                      ? () => decrement(totalHarga, hargaSatuan)
                                      : null,
                                  child: SizedBox(
                                    width: 20,
                                    child: Obx(
                                      () => Text(
                                          kasir.checkBayar.value ? '-' : '',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 40,
                                              color: AppColors.primaryColor)),
                                    ),
                                  )),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  '${kasir.dataKasir[widget.index].qtyPembelian}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => GestureDetector(
                                  onTap: kasir.checkBayar.value
                                      ? () => increment(totalHarga, hargaSatuan)
                                      : null,
                                  child: SizedBox(
                                    width: 20,
                                    child: Obx(
                                      () => Text(
                                        kasir.checkBayar.value ? '+' : '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 25,
                                            color: AppColors.primaryColor),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ))),
            Container(
              width: size.width,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        )),
                    Row(
                      children: [
                        Obx(
                          () => GestureDetector(
                              onTap: kasir.checkBayar.value
                                  ? () {
                                      kasir.updateTotalPembelian();
                                      kasir.delete(
                                          kasir.dataKasir[widget.index].id!);
                                    }
                                  : null,
                              child: SizedBox(
                                width: 30,
                                child: Obx(
                                  () => Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: kasir.checkBayar.value
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              )),
                        ),
                        StreamBuilder<Object>(
                            stream: kasir.dataKasir.stream,
                            builder: (context, snapshot) {
                              return Text(
                                  current.format(
                                      kasir.dataKasir[widget.index].totalHarga),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold));
                            }),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
