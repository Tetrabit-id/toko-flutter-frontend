import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/loading_cilcular.dart';
import '../../../components/rekap_kas_card.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class RekapKasPage extends StatefulWidget {
  const RekapKasPage({super.key});

  @override
  State<RekapKasPage> createState() => _RekapKasPageState();
}

class _RekapKasPageState extends State<RekapKasPage> {
  @override
  void initState() {
    super.initState();

    // // init data member
    rekapKas.foundKas = getApiRekapKas.dataKas;

    // init data cabang untuk add member
    getApiCabang.getAPI();
    getApiCabang.dataCabangOwner;
  }

  void filterUser(String keyword) {
    List resultFilter = [];

    if (keyword.isEmpty) {
      resultFilter = getApiRekapKas.dataKas.toList();
    } else {
      var results = getApiRekapKas.dataKas.toList();

      resultFilter = results
          .where((element) => element['kasAwal']!.toString().contains(keyword))
          .toList();
    }
    setState(() {
      rekapKas.foundKas = resultFilter.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    TextEditingController searchC = TextEditingController();
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerPelangganPage(querySize.size, searchC),
        body: RefreshIndicator(
          onRefresh: () => getApiRekapKas.getApi(),
          child: FutureBuilder(
              future: getApiRekapKas.getApi(),
              initialData: rekapKas.foundKas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingCilcular();
                }
                return Obx(
                  () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: getApiRekapKas.dataKas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppSvg.notFoundUserSvg,
                                  const SizedBox(height: 25),
                                  headerNotFound(
                                      'Tidak ada rekap kas ditambahkan'),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(color: Colors.grey, height: 25),
                              itemCount: rekapKas.foundKas.length,
                              itemBuilder: (context, index) =>
                                  RekapKasCard(index: index),
                            )),
                );
              }),
        ),
        floatingActionButton: IconButton(
            iconSize: 56,
            onPressed: () => Get.toNamed(RouteName.addRekapKas),
            icon: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(46, 44, 44, 1),
                    borderRadius: BorderRadius.all(Radius.circular(28))),

                // ignore: prefer_const_constructors
                child: Icon(
                  size: 30,
                  color: Colors.white,
                  Icons.add,
                ))),
      ),
    );
  }

  AppBar headerPelangganPage(Size size, TextEditingController searchC) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: const Text('Rekap Kas',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
      bottom: PreferredSize(
        preferredSize: Size(size.width, 25),
        child: Column(
          children: [
            textFieldDefaultIcon(
              'Cari tanggal rekap kas..',
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
