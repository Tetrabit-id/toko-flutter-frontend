import 'package:diatera_pos/style/styles.dart';
import 'package:flutter/material.dart';
import '../../../routes/index_screens.dart';
import '../../../routes/navbar.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

int navigation = 0;

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
          body: Responsive.isMobile(context)
              ? screens[navigation]
              : screensTablet[navigation],
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColors.bgGrey,
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
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
                  destinations: navbar,
                )),
          )),
    );
  }
}
