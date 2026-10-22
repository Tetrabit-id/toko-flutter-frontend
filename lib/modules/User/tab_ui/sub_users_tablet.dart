import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:diatera_pos/components/user_card.dart';

import '../../../components/loading_cilcular.dart';
import '../../../constructors/button_primary.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_field_rounded.dart';
import '../../../constructors/text_style.dart';
import '../../../models/cabang.dart';
import '../../../routes/base_url.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class SubUserPageforTablet extends StatefulWidget {
  const SubUserPageforTablet({Key? key}) : super(key: key);

  @override
  State<SubUserPageforTablet> createState() => _SubUserPageforTabletState();
}

class _SubUserPageforTabletState extends State<SubUserPageforTablet> {
  @override
  void initState() {
    super.initState();
    // // init data karyawan
    karyawan.foundUser = getApiUsersK.dataUKaryawan;

    // init data cabang untuk add karyawan
    getApiCabang.getAPI();
    getApiCabang.dataCabangOwner;
  }

  void filterUser(String keyword) {
    List resultFilter = [];
    if (keyword.isEmpty) {
      resultFilter = getApiUsersK.dataUKaryawan.toList();
    } else {
      var results = getApiUsersK.dataUKaryawan.toList();

      resultFilter = results
          .where((element) =>
              element.name!.toLowerCase().contains(keyword.toLowerCase()) ||
              element.email!.toLowerCase().contains(keyword.toLowerCase()) ||
              element.role!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      karyawan.foundUser = resultFilter.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('User',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            const SizedBox(width: 15),
                            Expanded(
                              child: textFieldDefaultIcon(
                                'Cari nama karyawan, role, email',
                                const Size(50, 20),
                                false,
                                const Icon(Icons.search),
                                (value) => filterUser(value),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: getApiUsersK.getApi(),
                          initialData: karyawan.foundUser,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LoadingCilcular();
                            }
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: getApiUsersK.dataUKaryawan.isEmpty
                                    ? SizedBox(
                                        height: size.height / 0.8,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AppSvg.notFoundUserSvg,
                                            const SizedBox(height: 25),
                                            headerNotFound(
                                                'Belum ada user lain nih..'),
                                            const SizedBox(height: 10),
                                          ],
                                        )))
                                    : ListView.builder(
                                        itemCount: karyawan.foundUser.length,
                                        itemBuilder: (context, index) =>
                                            UserCard(index: index),
                                      ));
                          }),
                    ],
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    color: AppColors.bgGrey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  fillColor: AppColors.primaryColor,
                                  selectedColor: Colors.white,
                                  isSelected: karyawan.isSelected,
                                  children: const <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('Kasir'),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                          () {
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
                            postApiRegiterK.connectAPI(
                              karyawan.cabangIdKryC,
                              karyawan.emailNewKryC.text,
                              karyawan.pwNewKryC.text,
                              karyawan.nameNewKryC.text,
                              token.read('store'),
                              token.read('email'),
                              karyawan.role,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
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
          karyawan.cabangIdKryC = value?.id ?? '';
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
