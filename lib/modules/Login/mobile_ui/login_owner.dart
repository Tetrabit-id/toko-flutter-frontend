import 'package:diatera_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constructors/button_primary.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';

import '../../../routes/route.dart';
import '../../../style/styles.dart';

class LoginOwner extends StatefulWidget {
  const LoginOwner({super.key});

  @override
  State<LoginOwner> createState() => _LoginOwnerState();
}

class _LoginOwnerState extends State<LoginOwner> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height / 10),
                      headerOne('Hai,'),
                      headerOne('login dengan akunmu.'),
                      const SizedBox(height: 10),
                      paragraf(
                        'Masukkan kembali kredensial akunmu untuk bisa masuk otomatis ke dalam app.',
                        TextAlign.start,
                      ),
                      const SizedBox(height: 60),
                    ])),
            buttonPrimaryImg(
              'Masuk dengan Google',
              Colors.white,
              AppColors.colorFontPrimary,
              AppColors.primaryColor,
              Size(size.width - 100, size.height / 20),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: AppImages.logoGoogle),
              () => auth.loginOwnerbyGoogle(),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    color: Colors.black, width: size.width / 4, height: 1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('atau'),
                ),
                Container(
                    color: Colors.black, width: size.width / 4, height: 1),
              ],
            ),
            const SizedBox(height: 15),
            TextFieldDefault(
              label: "email",
              controller: auth.emailLogC,
              size: size,
              onChanged: (value) {},
            ),
            const SizedBox(height: 15),
            TextFieldDefault(
              label: "password",
              controller: auth.passwordLogC,
              size: size,
              obscureText: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 5),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 16),
                child: CheckboxListTile(
                  value: auth.checkedLogin,
                  onChanged: (value) {
                    setState(() {
                      auth.checkedLogin = value!;
                    });
                  },
                  title: const Text('Remember me'),
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            const SizedBox(height: 15),
            buttonPrimary(
                'Masuk',
                (auth.emailLogC.text != '' && auth.passwordLogC.text != '')
                    ? AppColors.primaryColor
                    : Colors.grey,
                Colors.white,
                Colors.transparent,
                Size(size.width - 100, size.height / 20), () {
              setState(() {
                if (auth.emailLogC.text == '' &&
                    auth.passwordLogC.text == '' &&
                    auth.checkedLogin != true) {
                  return;
                } else {
                  auth.loginOwner(
                    auth.emailLogC.text,
                    auth.passwordLogC.text,
                  );
                }
              });
            }),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              paragrafSecond(
                  'Baru pertama kali pakai App?    ', TextAlign.center),
              GestureDetector(
                onTap: () => Get.toNamed(RouteName.signUpMobile),
                child: const Text(
                  "Daftar",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15,
                    fontFamily: 'Lato',
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
