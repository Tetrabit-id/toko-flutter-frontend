import 'package:diatera_pos/constructors/button_primary.dart';
import 'package:diatera_pos/constructors/text_field_rounded.dart';
import 'package:diatera_pos/models/cabang.dart';
import 'package:diatera_pos/routes/base_url.dart';
import 'package:diatera_pos/style/styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/state_global.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  void initState() {
    super.initState();
    karyawan.roles[0];
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
                  karyawan.nameNewKryC.clear();
                  karyawan.emailNewKryC.clear();
                  karyawan.pwNewKryC.clear();
                  karyawan.cabangIdKryC = '';
                  karyawan.isSelected = [true, false];
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            title: const Text('Tambah User',
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
                    textFieldRounded(
                      'Nama Karyawan',
                      karyawan.nameNewKryC,
                      false,
                      TextInputType.text,
                      false,
                      size,
                    ),
                    textFieldRounded(
                      'Email',
                      karyawan.emailNewKryC,
                      false,
                      TextInputType.emailAddress,
                      false,
                      size,
                    ),
                    textFieldRounded(
                      'Password',
                      karyawan.pwNewKryC,
                      false,
                      TextInputType.name,
                      false,
                      size,
                    ),
                    const SizedBox(height: 12),
                    dropdownCabang(size),
                    const SizedBox(height: 12),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 5),
                        Text(
                          'Mohon data user jangan sampai terlupa!!',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pilih Role User'),
                          SizedBox(
                            height: 30,
                            child: ToggleButtons(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              fillColor: AppColors.primaryColor,
                              selectedColor: Colors.white,
                              isSelected: karyawan.isSelected,
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Kasir'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('Gudang'),
                                ),
                              ],
                              onPressed: (int newValue) {
                                setState(() {
                                  for (int i = 0;
                                      i < karyawan.isSelected.length;
                                      i++) {
                                    if (i == newValue) {
                                      karyawan.isSelected[i] = true;
                                    } else {
                                      karyawan.isSelected[i] = false;
                                    }
                                  }
                                  for (int i = 0;
                                      i < karyawan.roles.length;
                                      i++) {
                                    if (i == newValue) {
                                      karyawan.role = karyawan.roles[i];
                                    }
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    buttonPrimary(
                      'Tambah User',
                      AppColors.primaryColor,
                      Colors.white,
                      Colors.transparent,
                      Size(size.width - 140, size.height / 20),
                      () async {
                        bool validationEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(karyawan.emailNewKryC.text);
                        if (validationEmail != true) {
                          Get.snackbar(
                            'Email tidak valid',
                            'Mohon gunakan `@` pada pengisian email',
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent,
                            margin: const EdgeInsets.only(
                                top: 10, right: 10, left: 10),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                          );
                          karyawan.emailNewKryC.clear();
                          return;
                        }
                        if (karyawan.pwNewKryC.text.length < 6) {
                          Get.snackbar(
                            'Password tidak valid',
                            'Mohon masukkan 6 karakter pada pengisian password',
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent,
                            margin: const EdgeInsets.only(
                                top: 10, right: 10, left: 10),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                          );
                          karyawan.pwNewKryC.clear();
                          return;
                        }

                        await postApiRegiterK.connectAPI(
                          karyawan.cabangIdKryC,
                          karyawan.emailNewKryC.text,
                          karyawan.pwNewKryC.text,
                          karyawan.nameNewKryC.text,
                          token.read('store'),
                          token.read('email'),
                          karyawan.role,
                        );

                        setState(() {
                          karyawan.cabangIdKryC = '';
                          karyawan.cabangC = null;
                        });
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
      selectedItem: karyawan.cabangC?.id == '' ? null : karyawan.cabangC,
      onChanged: (value) {
        setState(() {
          karyawan.cabangIdKryC = value?.id ?? '';
          if (value != null) {
            karyawan.cabangC = value;
          }
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
