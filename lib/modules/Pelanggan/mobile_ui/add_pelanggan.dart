import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/constructors/text_field_rounded.dart';
import 'package:tetrabit_toko_pos/models/cabang.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/base_url.dart';
import '../../../routes/state_global.dart';

class AddPelangganPage extends StatefulWidget {
  const AddPelangganPage({Key? key}) : super(key: key);

  @override
  State<AddPelangganPage> createState() => _AddPelangganPageState();
}

class _AddPelangganPageState extends State<AddPelangganPage> {
  @override
  void initState() {
    super.initState();
    getApiCabang.dataCabangOwner;
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  pelanggan.nameNewPlgnC.clear();
                  pelanggan.nikNewPlgnC.clear();
                  pelanggan.emailNewPlgnC.clear();
                  pelanggan.phoneNewPlgnC.clear();
                  pelanggan.addressNewPlgnC.clear();
                  pelanggan.cabangIdPlgnC = '';
                  nfc.dataNfc.value = '';
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: const Text('Tambah Pelanggan',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600)),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSvg.userSvg,
                    const SizedBox(height: 20),
                    Obx(
                      () => GestureDetector(
                          onTap: () => nfc.readNFC(),
                          child: Container(
                            width: querySize.size.width / 1.26,
                            height: querySize.size.height / 18,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  nfc.dataNfc.value.isEmpty
                                      ? 'Member ID [ Scan KTP ]'
                                      : 'Member ID : ${nfc.dataNfc.value}',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                nfc.dataNfc.value.isEmpty
                                    ? const Icon(
                                        Icons.touch_app_rounded,
                                        color: Colors.white,
                                      )
                                    : GestureDetector(
                                        onTap: () => setState(() {
                                          nfc.dataNfc.value = '';
                                        }),
                                        child: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(height: 12),
                    textFieldRounded(
                      'Nama Pelanggan',
                      pelanggan.nameNewPlgnC,
                      false,
                      TextInputType.text,
                      false,
                      querySize.size,
                    ),
                    textFieldRounded(
                      'NIK Pelanggan',
                      pelanggan.nikNewPlgnC,
                      false,
                      TextInputType.text,
                      false,
                      querySize.size,
                    ),
                    textFieldRounded(
                      'Email',
                      pelanggan.emailNewPlgnC,
                      false,
                      TextInputType.emailAddress,
                      false,
                      querySize.size,
                    ),
                    textFieldRounded(
                      'Phone',
                      pelanggan.phoneNewPlgnC,
                      false,
                      TextInputType.number,
                      false,
                      querySize.size,
                    ),
                    textFieldRounded(
                      'Lokasi',
                      pelanggan.addressNewPlgnC,
                      false,
                      TextInputType.text,
                      false,
                      querySize.size,
                    ),
                    const SizedBox(height: 12),
                    dropdownCabang(querySize.size),
                    const SizedBox(height: 50),
                    buttonPrimary(
                      'Tambah Pelanggan',
                      AppColors.primaryColor,
                      Colors.white,
                      Colors.transparent,
                      Size(querySize.size.width - 140,
                          querySize.size.height / 20),
                      () {
                        bool validationEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(pelanggan.emailNewPlgnC.text);
                        if (validationEmail != true) {
                          snackbarNotif.unsuccess(
                            'Email tidak valid',
                            'Mohon gunakan `@` pada pengisian email',
                          );
                          pelanggan.emailNewPlgnC.clear();
                          return;
                        }

                        postApiInsertPelanggan.connectAPI(
                          token.read('_id'),
                          pelanggan.cabangIdPlgnC,
                          nfc.dataNfc.value,
                          pelanggan.nikNewPlgnC.text,
                          pelanggan.emailNewPlgnC.text,
                          pelanggan.nameNewPlgnC.text,
                          pelanggan.phoneNewPlgnC.text,
                          pelanggan.addressNewPlgnC.text,
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  DropdownSearch<Cabang> dropdownCabang(Size size) {
    return DropdownSearch<Cabang>(
      dropdownBuilder: (context, selectedItem) => Text(
        selectedItem?.name.toString() ?? "Pilih Cabang Penyimpanan Stok",
        style: TextStyle(
          fontSize: 15,
          color: selectedItem?.name.toString() != null
              ? Colors.black
              : const Color.fromARGB(156, 0, 0, 0),
        ),
      ),
      onChanged: (value) {
        setState(() {
          pelanggan.cabangIdPlgnC = value?.id ?? '';
        });
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          labelText: "Pilih Cabang",
          filled: true,
        ),
      ),
      clearButtonProps: const ClearButtonProps(isVisible: true),
      items: getApiCabang.dataCabangOwner.toList(),
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            title: Text('${item.name}'),
          ),
        ),
      ),
    );
  }
}
