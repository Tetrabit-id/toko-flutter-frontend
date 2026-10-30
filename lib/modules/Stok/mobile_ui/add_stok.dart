import 'dart:io';

import 'package:tetrabit_toko_pos/components/add_kategori_produk_popup.dart';
import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/constructors/text_field_rounded.dart';
import 'package:tetrabit_toko_pos/models/kategori.dart';
import 'package:tetrabit_toko_pos/models/merk.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:get/get.dart';
import '../../../components/add_merk_produk_popup.dart';
import '../../../components/pilih_atribut_field.dart';
import '../../../routes/state_global.dart';

class AddStokPage extends StatefulWidget {
  const AddStokPage({Key? key}) : super(key: key);

  @override
  State<AddStokPage> createState() => _AddStokPageState();
}

class _AddStokPageState extends State<AddStokPage> {
  String? scannerQr = '';

  @override
  void initState() {
    super.initState();
    // Halaman ini bisa dibuka dari Beranda tanpa memuat kategori & merk dulu
    getApiKategoriProduk.getApi();
    getApiMerkProduk.getApi();
  }

  @override
  Widget build(BuildContext context) {
    var namaBarang = stok.nmBrgC;
    var kodeBarang = stok.kodeBrgC;
    var qty = stok.qtyBrgC;
    var satuan = stok.satuanBrgC;
    var harga = stok.hrgBrgC;
    var hargaBeli = stok.hrgBeliBrgC;
    final querySize = MediaQuery.of(context);

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

    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: const Text('Tambah Barang',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600)),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await getApiKategoriProduk.getApi();
              await getApiMerkProduk.getApi();
              getApiKategoriProduk.dataKategoriProduk.refresh();
              getApiMerkProduk.dataMerkProduk.refresh();
            },
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      picker.imagePath!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                    width: querySize.size.width / 1.7,
                                    height: querySize.size.width / 1.7,
                                    child: CircleAvatar(
                                        // Web: path berupa blob URL
                                        backgroundImage: kIsWeb
                                            ? NetworkImage(
                                                picker.imagePath!.value)
                                            : FileImage(File(
                                                    picker.imagePath!.value))
                                                as ImageProvider)),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.white),
                                    onPressed: () => setState(
                                        () => picker.imagePath!.value = ''),
                                    child: const Icon(
                                      Icons.delete,
                                      size: 24,
                                      color: Colors.red,
                                    ))
                              ],
                            )
                          : AppSvg.stokSvg,
                      const SizedBox(height: 20),
                      dropDownAtributeProduk(querySize.size),
                      const SizedBox(height: 24),
                      Container(
                          width: querySize.size.width,
                          height: 1,
                          color: Colors.grey),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => scanQR(),
                            child: const SizedBox(
                              width: 50,
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
                              querySize.size,
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
                        querySize.size,
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
                              querySize.size,
                              4,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              flex: 60,
                              child: dropDownSatuan(querySize, satuan)),
                        ],
                      ),
                      textFieldRoundedCurrentwithHint(
                        'Harga Jual per satuan',
                        harga,
                        false,
                        TextInputType.number,
                        'Rp.',
                        TextAlign.start,
                        querySize.size,
                      ),
                      textFieldRoundedCurrentwithHint(
                        'Harga Beli per satuan',
                        hargaBeli,
                        false,
                        TextInputType.number,
                        'Rp.',
                        TextAlign.start,
                        querySize.size,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Masukkan Photo'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    await picker.imagePickerByCamera();
                                    setState(() => picker.imagePath);
                                  },
                                  child: const Icon(Icons.add_a_photo_rounded,
                                      size: 18)),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                  onPressed: () async {
                                    await picker.imagePickerByGallery();
                                    setState(() => picker.imagePath);
                                  },
                                  child: const Icon(
                                    Icons.add_photo_alternate,
                                    size: 18,
                                  ))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      StreamBuilder(
                        stream: stok.loading.stream,
                        builder: (context, snapshot) =>
                            buttonPrimaryWithLoading(
                                'Tambah',
                                kodeBarang.text != '' &&
                                        namaBarang.text != '' &&
                                        qty.text != '' &&
                                        satuan.text != '' &&
                                        harga.text != '' &&
                                        stok.kategoriIdPrdC != '' &&
                                        stok.merkIdPrdC != '' &&
                                        picker.imagePath!.value.isNotEmpty
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                Colors.white,
                                Colors.transparent,
                                Size(querySize.size.width - 140,
                                    querySize.size.height / 20),
                                stok.loading.value,
                                () => setState(() {
                                      stok.addStok(
                                        kodeBarang.text,
                                        stok.kategoriIdPrdC,
                                        stok.merkIdPrdC,
                                        namaBarang.text,
                                        qty.text,
                                        satuan.text,
                                        harga.text,
                                        picker.imagePath!.value,
                                        hargaBeli.text,
                                      );
                                      picker.imagePath!.value = '';
                                    })),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Column dropDownAtributeProduk(Size size) {
    Future<void> addMerkProduk() async {
      await token.read('_id');

      return Get.defaultDialog(
        title: 'Tambah Merk',
        titlePadding: const EdgeInsets.only(top: 20),
        content: const PopUpMerkProduk(),
      );
    }

    Future<void> addKategoriProduk() async {
      await token.read('_id');

      return Get.defaultDialog(
        title: 'Tambah Kategori',
        titlePadding: const EdgeInsets.only(top: 20),
        content: const PopUpKategoriProduk(),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => addKategoriProduk(),
              child: const SizedBox(
                width: 50,
                child: Icon(
                  Icons.post_add_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Expanded(flex: 60, child: dropDownKategori(addKategoriProduk)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            GestureDetector(
              onTap: () => addMerkProduk(),
              child: const SizedBox(
                width: 50,
                child: Icon(
                  Icons.add_circle,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Expanded(flex: 60, child: dropDownMerk(addMerkProduk)),
          ],
        ),
      ],
    );
  }

  DropdownSearch<String> dropDownSatuan(
      MediaQueryData querySize, TextEditingController satuan) {
    return DropdownSearch<String>(
      items: const ["pcs", "g", "kg", "ons", "liter", "karung"],
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding:
              EdgeInsets.symmetric(horizontal: querySize.size.width / 20),
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          labelText: "Pilih Satuan",
          filled: true,
        ),
      ),
      onChanged: (value) {
        setState(() {
          satuan.text = value ?? '';
        });
      },
    );
  }

  PilihAtributField<Kategori> dropDownKategori(
      Future<void> Function() addKategori) {
    return PilihAtributField<Kategori>(
      label: 'Kategori',
      items: getApiKategoriProduk.dataKategoriProduk,
      idOf: (item) => item.id,
      nameOf: (item) => item.name,
      selectedId: stok.kategoriIdPrdC,
      onChanged: (id) => setState(() => stok.kategoriIdPrdC = id),
      onAdd: addKategori,
      onDelete: (item) => getApiKategoriProduk.delete(item.id),
    );
  }

  PilihAtributField<Merk> dropDownMerk(Future<void> Function() addMerk) {
    return PilihAtributField<Merk>(
      label: 'Merk',
      items: getApiMerkProduk.dataMerkProduk,
      idOf: (item) => item.id,
      nameOf: (item) => item.name,
      selectedId: stok.merkIdPrdC,
      onChanged: (id) => setState(() => stok.merkIdPrdC = id),
      onAdd: addMerk,
      onDelete: (item) => getApiMerkProduk.delete(item.id),
    );
  }
}
