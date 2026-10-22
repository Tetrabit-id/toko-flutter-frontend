import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/constructors/text_field_rounded.dart';
import 'package:tetrabit_toko_pos/models/cabang.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/base_url.dart';
import '../../../routes/state_global.dart';

class AddRekapKasPage extends StatefulWidget {
  const AddRekapKasPage({Key? key}) : super(key: key);

  @override
  State<AddRekapKasPage> createState() => _AddRekapKasPageState();
}

class _AddRekapKasPageState extends State<AddRekapKasPage> {
  @override
  void initState() {
    super.initState();
    getApiCabang.dataCabangOwner;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  rekapKas.kasAwalNewRekapC.clear();
                  rekapKas.cabangIdRekapC = '';
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: const Text('Tambah Kas',
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
                    textFieldRoundedCurrentwithHint(
                      'Kas Awal',
                      rekapKas.kasAwalNewRekapC,
                      false,
                      TextInputType.number,
                      'Rp.',
                      TextAlign.start,
                      size,
                    ),
                    const SizedBox(height: 12),
                    dropdownCabang(size),
                    const SizedBox(height: 50),
                    buttonPrimary(
                      'Tambah Kas',
                      AppColors.primaryColor,
                      Colors.white,
                      Colors.transparent,
                      Size(size.width - 140, size.height / 20),
                      () {
                        postApiInsertRekapKas.connectAPI(
                          token.read('_id'),
                          rekapKas.cabangIdRekapC,
                          int.parse(rekapKas.kasAwalNewRekapC.text
                              .replaceAll(',', '')
                              .substring(4)),
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
          rekapKas.cabangIdRekapC = value?.id ?? '';
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
