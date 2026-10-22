import 'package:tetrabit_toko_pos/components/loading_cilcular.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tetrabit_toko_pos/components/user_card.dart';

import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class SubUserPage extends StatefulWidget {
  const SubUserPage({Key? key}) : super(key: key);

  @override
  State<SubUserPage> createState() => _SubUserPageState();
}

class _SubUserPageState extends State<SubUserPage> {
  @override
  void initState() {
    super.initState();

    // // init data karyawan
    karyawan.foundUser = getApiUsersK.dataUKaryawan;

    // init data cabang untuk add karyawan
    getApiCabang.getAPI();
    getApiCabang.dataCabangOwner;
  }

  void filterUser(String keyword) {
    List resultFilter = [];

    if (keyword.isEmpty) {
      resultFilter = getApiUsersK.dataUKaryawan.toList();
    } else {
      var results = getApiUsersK.dataUKaryawan.toList();

      resultFilter = results
          .where((element) =>
              element['name']!.toLowerCase().contains(keyword.toLowerCase()) ||
              element['email']!.toLowerCase().contains(keyword.toLowerCase()) ||
              element['role']!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      karyawan.foundUser = resultFilter.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    TextEditingController searchC = TextEditingController();
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: headerUserPage(querySize.size, searchC, () {
            setState(() {});
            getApiUsersK.getApi();
          }),
          body: RefreshIndicator(
            onRefresh: () => getApiUsersK.getApi(),
            child: FutureBuilder(
                future: getApiUsersK.getApi(),
                initialData: karyawan.foundUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingCilcular();
                  }
                  return Obx(
                    () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: getApiUsersK.dataUKaryawan.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppSvg.notFoundUserSvg,
                                    const SizedBox(height: 25),
                                    headerNotFound(
                                        'Tidak ada karyawan ditambahkan'),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: karyawan.foundUser.length,
                                itemBuilder: (context, index) =>
                                    UserCard(index: index),
                              )),
                  );
                }),
          )),
    );
  }

  AppBar headerUserPage(
      Size size, TextEditingController searchC, Function onBack) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      title: const Text('Karyawan',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            padding: const EdgeInsets.only(right: 15),
            onPressed: () async {
              await Get.toNamed(RouteName.addUser);

              onBack();
            },
            icon: Container(
              width: 100,
              height: 32,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(46, 44, 44, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const Icon(
                Icons.add,
              ),
            ))
      ],
      toolbarHeight: 90,
      bottom: PreferredSize(
        preferredSize: Size(size.width, 25),
        child: Column(
          children: [
            textFieldDefaultIcon(
              'Cari nama karyawan, role, email',
              const Size(115, 20),
              false,
              const Icon(Icons.search),
              (value) => filterUser(value),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
