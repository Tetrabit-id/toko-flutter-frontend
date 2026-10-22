import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tetrabit_toko_pos/constructors/button_primary.dart';
import 'package:tetrabit_toko_pos/constructors/text_field_default.dart';
import 'package:tetrabit_toko_pos/constructors/text_style.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';

import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../services/plan_service.dart';

class SignUpPageMobile extends StatefulWidget {
  const SignUpPageMobile({Key? key}) : super(key: key);

  @override
  State<SignUpPageMobile> createState() => _SignUpPageMobileState();
}

class _SignUpPageMobileState extends State<SignUpPageMobile> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  postApiRegisterO.usernameNewC.clear();
                  postApiRegisterO.emailNewC.clear();
                  postApiRegisterO.storeNewC.clear();
                  postApiRegisterO.passwordNewC.clear();
                  postApiRegisterO.repasswordNewC.clear();
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            title: AppImages.logoFull,
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: Responsive.isMobile(context)
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: Responsive.isMobile(context)
                            ? const EdgeInsets.symmetric(horizontal: 40)
                            : const EdgeInsets.all(0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              headerOne('Halo,'),
                              headerOne('Pengguna Baru !!'),
                              const SizedBox(height: 10),
                              paragraf(
                                'Buat Akunmu dan kendalikan seluruh transaksi penjualanmu.',
                                TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Chip(
                                    backgroundColor: AppColors.primaryColor,
                                    label: Text(
                                      postApiRegisterO.plan == 'offline'
                                          ? planOffline.nama
                                          : planSubscription.nama,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Ganti Paket',
                                        style: TextStyle(
                                            color: AppColors.primaryColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ])),
                    buttonPrimaryImg(
                      'Daftar dengan Google',
                      Colors.white,
                      AppColors.colorFontPrimary,
                      AppColors.primaryColor,
                      Size(size.width - 100, size.height / 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: AppImages.logoGoogle),
                      () => auth.loginOwnerbyGoogle(),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            color: Colors.black,
                            width: size.width / 4,
                            height: 1),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('atau'),
                        ),
                        Container(
                            color: Colors.black,
                            width: size.width / 4,
                            height: 1),
                      ],
                    ),
                    const SizedBox(height: 15),
                    textFieldDefault("name lengkap", size,
                        postApiRegisterO.usernameNewC, false),
                    const SizedBox(height: 15),
                    textFieldDefault(
                        "email", size, postApiRegisterO.emailNewC, false),
                    const SizedBox(height: 15),
                    textFieldDefault(
                        "nama toko", size, postApiRegisterO.storeNewC, false),
                    const SizedBox(height: 15),
                    textFieldDefault(
                        "password", size, postApiRegisterO.passwordNewC, true),
                    const SizedBox(height: 15),
                    textFieldDefault("ulangi password", size,
                        postApiRegisterO.repasswordNewC, true),
                    const SizedBox(height: 5),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width / 16),
                        child: CheckboxListTile(
                          value: checked,
                          onChanged: (value) {
                            setState(() {
                              checked = value!;
                            });
                          },
                          title: const Text(
                              'Saya setuju dengan syarat yang berlaku'),
                          controlAffinity: ListTileControlAffinity.leading,
                        )),
                    const SizedBox(height: 15),
                    buttonPrimary(
                        'Daftar',
                        postApiRegisterO.usernameNewC.text != '' &&
                                postApiRegisterO.emailNewC.text != '' &&
                                postApiRegisterO.storeNewC.text != '' &&
                                postApiRegisterO.passwordNewC.text != '' &&
                                postApiRegisterO.repasswordNewC.text != '' &&
                                checked == true
                            ? AppColors.primaryColor
                            : Colors.grey,
                        Colors.white,
                        Colors.transparent,
                        Size(size.width - 100, size.height / 20), () {
                      if (postApiRegisterO.usernameNewC.text == '' &&
                          postApiRegisterO.emailNewC.text == '' &&
                          postApiRegisterO.storeNewC.text == '' &&
                          postApiRegisterO.passwordNewC.text == '' &&
                          postApiRegisterO.repasswordNewC.text == '' &&
                          checked != true) {
                        return;
                      } else {
                        postApiRegisterO.connectAPI(
                          postApiRegisterO.emailNewC.text,
                          postApiRegisterO.passwordNewC.text,
                          postApiRegisterO.usernameNewC.text,
                          postApiRegisterO.storeNewC.text,
                        );
                      }
                      return;
                    }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        paragrafSecond(
                            'Sudah punya Akun?    ', TextAlign.center),
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteName.loginMobile),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 15,
                              fontFamily: 'Lato',
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
