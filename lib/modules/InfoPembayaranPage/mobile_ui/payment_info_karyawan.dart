import 'package:flutter/material.dart';
import '../../../constructors/text_style.dart';
import '../../../style/styles.dart';

class PaymentInfoForKaryawan extends StatefulWidget {
  const PaymentInfoForKaryawan({super.key});

  @override
  State<PaymentInfoForKaryawan> createState() => _PaymentInfoForKaryawanState();
}

class _PaymentInfoForKaryawanState extends State<PaymentInfoForKaryawan> {
  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  headerOne('Hmm.. Status Akun Ownermu Non-Aktif'),
                  const SizedBox(height: 25),
                  paragraf(
                    'Mohon menghubungi ownermu untuk mengaktifkan kembali akunnya agar pengalaman management-mu tidak terganggu.',
                    TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  AppSvg.paymentInfoSvg,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
