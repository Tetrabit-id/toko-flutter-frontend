import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import '../../../routes/index_screens.dart';
import '../../../routes/navbar.dart';
import '../../../routes/state_global.dart';
import '../../../components/sync_banner.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

int navigation = 0;

class _IndexPageState extends State<IndexPage> {
  // Index tab yang tersedia; paket offline tanpa tab Pengguna (karyawan)
  final tabs = paket.canKelolaKaryawan ? [0, 1, 2, 3, 4] : [0, 1, 2, 4];

  @override
  Widget build(BuildContext context) {
    if (navigation >= tabs.length) navigation = 0;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          body: Responsive.isMobile(context)
              ? screens[tabs[navigation]]
              : screensTablet[tabs[navigation]],
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColors.bgGrey,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SyncBanner(),
              Container(
                padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
                color: Colors.white,
                child: NavigationBarTheme(
                    data: NavigationBarThemeData(
                        indicatorColor: const Color.fromARGB(0, 255, 255, 255),
                        backgroundColor: Colors.white,
                        height: 65,
                        labelTextStyle: WidgetStateProperty.all(
                            const TextStyle(fontSize: 12, fontFamily: "Lato"))),
                    child: NavigationBar(
                      selectedIndex: navigation,
                      onDestinationSelected: (index) => setState(() {
                        navigation = index;
                      }),
                      destinations: tabs.map((i) => navbar[i]).toList(),
                    )),
              ),
            ],
          )),
    );
  }
}
