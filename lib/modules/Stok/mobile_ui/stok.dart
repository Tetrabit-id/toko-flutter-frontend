import 'package:tetrabit_toko_pos/modules/Stok/mobile_ui/body_stok.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/state_global.dart';

class StokPage extends StatefulWidget {
  const StokPage({Key? key}) : super(key: key);

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage>
    with SingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void initState() {
    setState(() {
      tabC = TabController(
        vsync: this,
        length: getApiCabang.dataCabangOwner.length,
      );
    });

    // init data cabang
    if (token.read('role') != 'admin') {
      return;
    }

    getApiCabang.getAPI();
    getApiCabang.dataCabangOwner;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);

    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerStokPage(querySize.size, token.read('role')),
        body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: token.read('role') != 'admin'
                ? BodyStok(
                    size: querySize.size,
                    idCabang: token.read('cabangId'),
                  )
                : TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabC,
                    children: List.generate(
                        getApiCabang.dataCabangOwner.length,
                        (index) => BodyStok(
                              size: querySize.size,
                              idCabang: getApiCabang.dataCabangOwner[index].id,
                            )))),
        floatingActionButton: token.read('role') == 'Kasir'
            ? const SizedBox()
            : IconButton(
                iconSize: 56,
                onPressed: () async {
                  await getApiKategoriProduk.getApi();
                  await getApiMerkProduk.getApi();
                  getApiKategoriProduk.dataKategoriProduk;
                  getApiMerkProduk.dataMerkProduk;

                  await Get.toNamed(RouteName.addStok);

                  setState(() {});
                  String idcabang = '';
                  if (getApiCabang.dataCabangOwner.length < 2) {
                    idcabang = token.read('cabangId') ?? localDb.cabangId;
                  } else {
                    String? id = getApiCabang.dataCabangOwner[tabC.index].id;
                    if (id != null) {
                      idcabang = id;
                    }
                  }

                  if (token.read('role') != 'admin') {
                    getApiStok.getAPI(token.read('parentId'), idcabang);
                  } else {
                    getApiStok.getAPI(token.read('_id'), idcabang);
                  }
                },
                icon: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
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

  // Widget Header
  AppBar headerStokPage(Size size, String role) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      title: const Text(
        'Stok Cabang',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: token.read('role') == 'Kasir' ? 60 : 80,
      bottom: token.read('role') == 'Kasir'
          ? null
          : PreferredSize(
              preferredSize: Size(size.width, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Paket offline hanya punya cabang Pusat
                  if (paket.canMultiCabang) ...[
                    Expanded(
                        flex: 15,
                        child: GestureDetector(
                          onTap: () => token.read('role') != 'admin'
                              ? null
                              : Get.toNamed(RouteName.addCabang),
                          child: SizedBox(
                              height: 35,
                              child: Icon(Icons.add_business_rounded,
                                  color: token.read('role') != 'admin'
                                      ? Colors.grey
                                      : Colors.black)),
                        )),
                    Container(width: 1, height: 35, color: Colors.grey),
                  ],
                  Expanded(
                      flex: 80,
                      child: getApiCabang.dataCabangOwner.length < 2 ||
                              token.read('role') != 'admin'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 18),
                                    width: 80,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.primaryColor),
                                    child: const Center(
                                        child: Text('Pusat',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ))))
                              ],
                            )
                          : TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 0,
                              isScrollable: true,
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              indicator: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              controller: tabC,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black38,
                              tabs: List.generate(
                                  getApiCabang.dataCabangOwner.length,
                                  (index) => SizedBox(
                                      width: 70,
                                      height: 35,
                                      child: Center(
                                          child: Text(
                                        '${getApiCabang.dataCabangOwner[index].name}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 15),
                                      ))))))
                ],
              ),
            ),
    );
  }
}
