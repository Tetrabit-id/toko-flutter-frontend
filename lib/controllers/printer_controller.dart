import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';

import '../style/styles.dart';

class PrinterController extends GetxController {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  BluetoothDevice? selectDevice;
  List<BluetoothDevice> devices = [];

  void printDataKasir(
      RxList dataKasir, String dataNmKry, String dataNmToko, kasir) {
    printer.isConnected.then((isConnected) {
      if (isConnected != true) {
        Get.snackbar(
          'Bluetooth Disconnected',
          'No Device Printer',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
        return;
      }
      printer.printNewLine();
      printer.printCustom(dataNmToko, 1, 1);
      printer.printNewLine();
      printer.printLeftRight('Tgl Transaksi',
          DateFormat('d/MM/y H:MM').format(DateTime.now()).toString(), 0);
      printer.printLeftRight('Nama Kasir', dataNmKry, 0);
      printer.printCustom('--------------------------', 1, 1);
      printer.print3Column('Barang', 'Harga', 'Total', 0);
      printer.printCustom('--------------------------', 1, 1);
      for (var i = 0; i < dataKasir.length; i++) {
        printer.print3Column(
            '${kasir.dataKasir[i].namaBarang}',
            '${current.format(dataKasir[i].hargaBarangStok).substring(4)} X ${dataKasir[i].qtyPembelian}',
            current.format(dataKasir[i].totalHarga).substring(4),
            0);
      }
      printer.printCustom('--------------------------', 1, 1);
      printer.printLeftRight(
          'Sub Transaksi',
          current.format(kasir.totalPembelian + kasir.discount).substring(4),
          0);
      printer.printLeftRight('Diskon', kasir.discount.toString(), 0);
      printer.printCustom('--------------------------', 1, 1);
      printer.printLeftRight('Total Belanja',
          current.format(kasir.totalPembelian).substring(4), 0);
      printer.printLeftRight('Bayar', (kasir.bayarC.text).substring(4), 0);
      printer.printLeftRight(
          'Kembalian', current.format(kasir.kembalian).substring(4), 0);
      printer.printNewLine();
      printer.printCustom('Terima Kasih', 1, 1);
      printer.paperCut();
    });
  }

  void printDataInvoice(RxList dataKasir) {
    printer.isConnected.then((isConnected) {
      if (isConnected != true) {
        Get.snackbar(
          'Bluetooth Disconnected',
          'No Device Printer',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
        return;
      }
      printer.printNewLine();
      printer.printCustom('Invoice', 1, 1);
      printer.printNewLine();
      printer.printCustom(
          dataKasir[0].noInvoice.toString().toUpperCase(), 1, 1);
      printer.printNewLine();
      printer.printLeftRight(
          'Nama Kasir', dataKasir[0].namaKasir.toString(), 0);
      printer.printLeftRight('Tgl Transaksi', dataKasir[0].date.toString(), 0);
      printer.printCustom('--------------------------', 1, 1);
      printer.print4Column('Barcode', 'Barang', 'Qty', 'Total', 0);
      printer.printCustom('--------------------------', 1, 1);

      for (var i = 0; i < dataKasir[0].idDataKasir[0].length; i++) {
        printer.print3Column(
            '${dataKasir[0].idDataKasir[0][i]['code']}',
            '${dataKasir[0].idDataKasir[0][i]['name']}    ',
            '${dataKasir[0].idDataKasir[0][i]['qty']}    ${current.format(dataKasir[0].idDataKasir[0][i]['total']).substring(4)}',
            0);
      }

      printer.printCustom('--------------------------', 1, 1);
      printer.printLeftRight('Sub Transaksi',
          current.format(dataKasir[0].subJumlahTransaksi).substring(4), 0);
      printer.printLeftRight('Diskon', dataKasir[0].discountUnit.toString(), 0);
      printer.printCustom('--------------------------', 1, 1);
      printer.printLeftRight('Total Belanja',
          current.format(dataKasir[0].amountInvoice).substring(4), 0);
      printer.printLeftRight(
          'Bayar', current.format(dataKasir[0].bayar).substring(4), 0);
      printer.printLeftRight(
          'Kembalian', current.format(dataKasir[0].kembalian).substring(4), 0);
      printer.printNewLine();
      printer.printCustom('Terima Kasih', 1, 1);
      printer.paperCut();
    });
  }

  void testPrint() {
    printer.printNewLine();
    printer.printCustom('Test Printer', 1, 1);
    printer.printNewLine();
    printer.printLeftRight('Tgl Transaksi', '01/01/2000', 0);
    printer.printLeftRight('Nama Kasir', 'Test Nama', 0);
    printer.printCustom('--------------------------', 1, 1);
    printer.print3Column('Qty     Barang', 'Harga', 'Total', 0);
    printer.printCustom('--------------------------', 1, 1);
    for (var i = 0; i < 2; i++) {
      printer.print3Column('2  Test Barang', '1,000,000', '2,000,000', 0);
    }
    printer.printCustom('--------------------------', 1, 1);
    printer.printLeftRight('Total Belanja', '4,000,000', 0);
    printer.printLeftRight('Bayar', '4,050,000', 0);
    printer.printLeftRight('Kembalian', '50,000', 0);
    printer.printNewLine();
    printer.printCustom('Terima Kasih', 1, 1);
    printer.paperCut();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    Get.defaultDialog(
        title: 'Select Printer',
        titlePadding: const EdgeInsets.only(top: 25),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        content: SizedBox(
          width: 500,
          height: 300,
          child: devices.isEmpty
              ? const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Device tidak ditemukan',
                      style: TextStyle(color: Colors.black38, fontSize: 18),
                    ),
                    Text(
                      'Mohon hidupkan Bluetooth',
                      style: TextStyle(color: Colors.black38, fontSize: 14),
                    ),
                  ],
                ))
              : ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          selectDevice = devices[index];
                          connectPrinter();
                        },
                        child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: devices[index].name != ''
                                      ? AppColors.borderColor
                                      : AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${devices[index].name}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text('${devices[index].address}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    )),
                              ],
                            )));
                  }),
        ),
        confirm: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                printer.isConnected.then((isConnected) {
                  if (isConnected != true) {
                    return null;
                  }
                  testPrint();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
              ),
              child: const Text('Test Print'),
            ),
            ElevatedButton(
              onPressed: () {
                printer.isConnected.then((isConnected) {
                  if (isConnected != true) {
                    return null;
                  }
                  printer.disconnect();
                });
                Get.snackbar(
                  'Bluetooth Disconnected',
                  'No Device Printer',
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                  margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  isDismissible: true,
                  dismissDirection: DismissDirection.horizontal,
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
              child: const Text('Disconnect Printer'),
            ),
          ],
        ));
  }

  void connectPrinter() {
    if (selectDevice != null) {
      printer.isConnected.then((isConnected) {
        isConnected = true;
        if (isConnected == true) {
          printer.connect(selectDevice!).catchError((error) {
            // ignore: avoid_print
            Get.snackbar(
              'Bluetooth Connected',
              'Device name : ${selectDevice!.name},  address : ${selectDevice!.address}',
              colorText: Colors.white,
              backgroundColor: AppColors.primaryColor,
              margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
              isDismissible: true,
              dismissDirection: DismissDirection.horizontal,
            );
          });
        }
      });
    } else {
      printer.isConnected.then((isConnected) => isConnected = false);
      // ignore: avoid_print
      print('No device selected.');
    }
  }
}
