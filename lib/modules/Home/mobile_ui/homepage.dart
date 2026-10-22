import 'package:tetrabit_toko_pos/components/loading_cilcular.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/stok_habis_card.dart';
import '../../../routes/state_global.dart';

import 'dropdown_setting.dart';
import 'sales_summary.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  @override
  void initState() {
    super.initState();
    getDataSummary.dataSummaryChart.clear();
    transaksi.dataLaporan7Ago.clear();
    getApiCabang.getAPI();
  }

  @override
  Widget build(BuildContext context) {
    List dataChart = getDataSummary.dataSummaryChart;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: AppImages.logoIconic,
            ),
            leadingWidth: querySize.size.width / 5,
            elevation: 0.5,
            backgroundColor: Colors.white,
            actions: [
              profile(),
              const DropdownSetting(),
            ],
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                await getApiStok.getAPI(
                    token.read('_id'), token.read('cabangId'));
                await getApiTransaksi.getApi();
                await token.read('name');
                setState(() {});
              },
              child: ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: querySize.size.height / 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          detailPemasukan(),
                          ElevatedButton(
                              onPressed: () => Get.toNamed(RouteName.detail),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(130, 0),
                                  backgroundColor: AppColors.primaryColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ))),
                              child: const Text('Lihat Detail',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lato',
                                  )))
                        ],
                      )),
                  SalesSummary(size: querySize.size, dataChart: dataChart),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Stok Habis',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          ElevatedButton(
                              onPressed: () => Get.toNamed(RouteName.addStok),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(46, 44, 44, 1),
                                shadowColor: Colors.transparent,
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add),
                                  Text('Tambah'),
                                ],
                              ))
                        ],
                      )),
                  CardStokHabis(size: querySize.size),
                  const SizedBox(height: 10),
                ],
              ))),
    );
  }

  Padding detailPemasukan() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Pemasukanmu',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          FutureBuilder(
              future: transaksi.getTotalPemasukkan(),
              initialData: transaksi.totalPemasukkan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingCilcular();
                }
                return Text(
                    current.format(transaksi.totalPemasukkan).substring(4),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ));
              })
        ],
      ),
    );
  }

  Column profile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Halo ${(token.read('role').toString().capitalizeFirst)},',
            style: const TextStyle(
                fontFamily: 'Lato', fontSize: 12, color: Colors.black)),
        Text(
          token.read('name').toString(),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        )
      ],
    );
  }
}
