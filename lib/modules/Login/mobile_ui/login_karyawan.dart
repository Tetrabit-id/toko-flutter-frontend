import 'package:flutter/material.dart';

import '../../../constructors/button_primary.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class LoginKaryawan extends StatefulWidget {
  const LoginKaryawan({super.key});

  @override
  State<LoginKaryawan> createState() => _LoginKaryawanState();
}

class _LoginKaryawanState extends State<LoginKaryawan> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String emailSubU = '';
    String passSubU = '';
    return SingleChildScrollView(
      child: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height / 10),
                  headerOne('Halo Karyawan,'),
                  headerOne('login dengan akunmu.'),
                  const SizedBox(height: 10),
                  paragraf(
                    'Masukkan email & password yang telah diberikan pemilik.',
                    TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFieldDefault(
              label: "email",
              controller: auth.emailKLogC,
              size: size,
              onChanged: (value) {
                setState(() {
                  emailSubU = value;
                });
              },
            ),
            const SizedBox(height: 15),
            TextFieldDefault(
              label: "password",
              controller: auth.passwordKLogC,
              size: size,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  passSubU = value;
                });
              },
            ),
            const SizedBox(height: 5),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 16),
                child: CheckboxListTile(
                  value: auth.checkedSubU,
                  onChanged: (value) {
                    setState(() {
                      auth.checkedSubU = value!;
                    });
                  },
                  title: const Text('Remember me'),
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            const SizedBox(height: 15),
            buttonPrimary(
                'Masuk',
                (auth.checkedSubU == true &&
                        emailSubU.isEmpty &&
                        passSubU.isEmpty)
                    ? AppColors.primaryColor
                    : Colors.grey,
                Colors.white,
                Colors.transparent,
                Size(size.width - 100, size.height / 20), () {
              setState(() {
                if (emailSubU.isEmpty &&
                    passSubU.isEmpty &&
                    auth.checkedLogin != false) {
                  return;
                } else {
                  auth.loginKaryawan(
                    auth.emailKLogC.text,
                    auth.passwordKLogC.text,
                  );
                }
              });
            }),
          ],
        ),
      ),
    );
  }
}
