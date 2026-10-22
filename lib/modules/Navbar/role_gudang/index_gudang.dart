import 'package:flutter/material.dart';
import 'package:diatera_pos/style/styles.dart';
import 'package:get/get.dart';
import '../../../routes/base_url.dart';
import '../../../routes/index_screens.dart';
import '../../../routes/navbar.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';

class IndexGudangPage extends StatefulWidget {
  const IndexGudangPage({Key? key}) : super(key: key);

  @override
  State<IndexGudangPage> createState() => _IndexGudangPageState();
}

int navigation = 0;

class _IndexGudangPageState extends State<IndexGudangPage> {
  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
          body: Responsive.isMobile(context)
              ? screensStok[navigation]
              : screensStokTablet[navigation],
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColors.bgGrey,
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.only(bottom: 5, right: 40, left: 10),
                color: Colors.white,
                child: NavigationBarTheme(
                    data: NavigationBarThemeData(
                        indicatorColor: const Color.fromARGB(0, 255, 255, 255),
                        backgroundColor: Colors.white,
                        height: 65,
                        labelTextStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 12, fontFamily: "Lato"))),
                    child: NavigationBar(
                      selectedIndex: navigation,
                      onDestinationSelected: (index) => setState(() {
                        navigation = index;
                      }),
                      destinations: navbarStok,
                    )),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 5, right: 15, left: 5),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            'Halo ${token.read('role') == 'admin' ? (token.read('role')).capitalizeFirst : token.read('role')},',
                            style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                color: Colors.black)),
                        Text(
                            '${token.read('name')[0] == token.read('name')[0].toLowerCase() ? (token.read('name')).capitalizeFirst : token.read('name')}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black))
                      ],
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        printer.getDevices();
                      },
                      child: const Icon(Icons.print, color: Colors.black),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          obrolan.karyawanId.value = token.read('_id');
                          obrolan.namaKaryawan.value = token.read('name');
                        });

                        await obrolan.getAPIObrolanByChannel(
                            'obrolan-${token.read('_id')}');

                        Get.toNamed(RouteName.pesan);
                      },
                      child:
                          const Icon(Icons.chat_rounded, color: Colors.black),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        auth.logout();
                      },
                      child: const Icon(Icons.logout, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
