import 'package:tetrabit_toko_pos/components/loading_cilcular.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../components/pelanggan_card.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({Key? key}) : super(key: key);

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  @override
  void initState() {
    super.initState();

    // // init data member
    pelanggan.foundPelanggan = getApiPelanggan.dataPelanggan;

    // init data cabang untuk add member
    getApiCabang.getAPI();
    getApiCabang.dataCabangOwner;
  }

  void filterUser(String keyword) {
    List resultFilter = [];

    if (keyword.isEmpty) {
      resultFilter = getApiPelanggan.dataPelanggan.toList();
    } else {
      var results = getApiPelanggan.dataPelanggan.toList();

      resultFilter = results
          .where((element) =>
              element['name']!.toLowerCase().contains(keyword.toLowerCase()) ||
              element['email']!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      pelanggan.foundPelanggan = resultFilter.obs;
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
            onRefresh: () => getApiPelanggan.getApi(),
            child: FutureBuilder(
                future: getApiPelanggan.getApi(),
                initialData: pelanggan.foundPelanggan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingCilcular();
                  }
                  return Obx(
                    () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: getApiPelanggan.dataPelanggan.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppSvg.notFoundUserSvg,
                                    const SizedBox(height: 25),
                                    headerNotFound(
                                        'Tidak ada pelanggan ditambahkan'),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: pelanggan.foundPelanggan.length,
                                itemBuilder: (context, index) =>
                                    PelangganCard(index: index),
                              )),
                  );
                }),
          )),
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
      title: const Text('Pelanggan',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            padding: const EdgeInsets.only(right: 15),
            onPressed: () => Get.toNamed(RouteName.addPelanggan),
            icon: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(46, 44, 44, 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ))
      ],
      toolbarHeight: 90,
      bottom: PreferredSize(
        preferredSize: Size(size.width, 25),
        child: Column(
          children: [
            textFieldDefaultIcon(
              'Cari member id..',
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
