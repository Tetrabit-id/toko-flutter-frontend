import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constructors/button_primary.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../style/styles.dart';

class PaymentInfoForOwner extends StatefulWidget {
  const PaymentInfoForOwner({super.key});

  @override
  State<PaymentInfoForOwner> createState() => _PaymentInfoForOwnerState();
}

class _PaymentInfoForOwnerState extends State<PaymentInfoForOwner> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    headerOne('Hmm.. Status Akunmu Non-Aktif'),
                    const SizedBox(height: 25),
                    paragraf(
                      'Yuk aktifin akunmu dan rasakan pengalaman management pos-mu "Jadi Lebih Baik".',
                      TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    AppSvg.paymentInfoSvg,
                    const SizedBox(height: 60),
                    buttonPrimary(
                        'Lanjut Pembayaran',
                        AppColors.primaryColor,
                        Colors.white,
                        Colors.transparent,
                        Size(size.width - 100, size.height / 20),
                        () => Get.toNamed(RouteName.paymentDetail)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
