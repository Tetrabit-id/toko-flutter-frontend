import 'package:tetrabit_toko_pos/modules/Login/mobile_ui/login_karyawan.dart';
import 'package:tetrabit_toko_pos/modules/Login/mobile_ui/login_owner.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/state_global.dart';

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({Key? key}) : super(key: key);

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile>
    with SingleTickerProviderStateMixin {
  late TabController tabC;

  @override
  void initState() {
    tabC = TabController(vsync: this, length: 2);
    super.initState();
  }

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
                setState(() {
                  auth.emailLogC.clear();
                  auth.passwordLogC.clear();
                  Get.back();
                });
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: AppImages.logoFull,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(size.width, 35),
            child: TabBar(
                controller: tabC,
                indicatorColor: AppColors.primaryColor,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black38,
                tabs: const [Tab(text: 'Pemilik'), Tab(text: 'Karyawan')]),
          ),
        ),
        body: TabBarView(
          controller: tabC,
          children: const [
            // Login Owner
            LoginOwner(),

            // Login Karyawan
            LoginKaryawan(),
          ],
        ),
      ),
    );
  }
}
