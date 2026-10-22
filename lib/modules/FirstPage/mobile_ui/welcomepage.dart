import 'package:diatera_pos/components/loading_cilcular.dart';
import 'package:diatera_pos/routes/route.dart';
import 'package:diatera_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constructors/button_primary.dart';
import '../../../constructors/text_style.dart';

class WelcomePageMobile extends StatefulWidget {
  const WelcomePageMobile({Key? key}) : super(key: key);

  @override
  State<WelcomePageMobile> createState() => _WelcomePageMobileState();
}

class _WelcomePageMobileState extends State<WelcomePageMobile> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return box.hasData('token')
        ? Container(color: Colors.white, child: const LoadingCilcular())
        : MediaQuery(
            data: querySize.copyWith(textScaleFactor: 0.81),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SizedBox(
                height: size.height,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          headerOne('Selamat Datang,'),
                          const SizedBox(height: 25),
                          paragraf(
                            'Kendalikan seluruh transaksi penjualanmu hanya dengan satu klik saja',
                            TextAlign.center,
                          ),
                          const SizedBox(height: 50),
                          AppSvg.welcomeSvg,
                          const SizedBox(height: 30),
                          buttonPrimary(
                              'Masuk',
                              AppColors.primaryColor,
                              Colors.white,
                              Colors.transparent,
                              Size(size.width - 100, size.height / 20),
                              () => Get.toNamed(RouteName.loginMobile)),
                          const SizedBox(height: 8),
                          buttonPrimary(
                              'Buat Akun Baru',
                              Colors.white,
                              const Color.fromRGBO(49, 49, 49, 1),
                              AppColors.primaryColor,
                              Size(size.width - 100, size.height / 20),
                              () => Get.toNamed(RouteName.signUpMobile)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
