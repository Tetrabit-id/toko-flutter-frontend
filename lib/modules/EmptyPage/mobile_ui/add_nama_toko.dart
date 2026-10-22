import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constructors/button_primary.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class AddNamaTokoPage extends StatefulWidget {
  const AddNamaTokoPage({super.key});

  @override
  State<AddNamaTokoPage> createState() => _AddNamaTokoPageState();
}

class _AddNamaTokoPageState extends State<AddNamaTokoPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: AppImages.logoFull,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10, vertical: size.height / 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                headerOne('Lanjutan'),
                const SizedBox(height: 25),
                paragraf(
                  'Masukkan nama toko & password.',
                  TextAlign.center,
                ),
                const SizedBox(height: 50),
                SvgPicture.asset('assets/svg/toko.svg'),
                const SizedBox(height: 30),
                TextFieldDefault(
                  label: "nama toko",
                  controller: auth.tokoEmptyC,
                  size: size,
                  onChanged: (value) {
                    setState(() {
                      value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFieldDefault(
                  label: "password akun",
                  controller: auth.passwordEmptyC,
                  size: size,
                  onChanged: (value) {
                    setState(() {
                      value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                buttonPrimary(
                    'Lanjut',
                    AppColors.primaryColor,
                    Colors.white,
                    Colors.transparent,
                    Size(size.width - 100, size.height / 20), () async {
                  if (auth.tokoEmptyC.text.isNotEmpty &&
                      auth.passwordEmptyC.text.isNotEmpty) {
                    return await auth.addEmptybyLoginGoogle(
                      capitalizeEachWord(auth.tokoEmptyC.text),
                      auth.passwordEmptyC.text,
                    );
                  }
                  Get.snackbar(
                    'Data Kosong',
                    'Masukkan nama toko',
                    colorText: Colors.white,
                    backgroundColor: Colors.redAccent,
                    margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
