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
          backgroundColor: AppColors.bgGrey,
          appBar: AppBar(
            leading: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: AppImages.logoIconic,
            ),
            leadingWidth: querySize.size.width / 5,
            elevation: 0.5,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
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
                  kartuPemasukan(),
                  SalesSummary(size: querySize.size, dataChart: dataChart),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.inventory_2_outlined,
                                  color: Colors.redAccent, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text('Stok Habis',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                            ),
                            TextButton.icon(
                              onPressed: () => Get.toNamed(RouteName.addStok),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Tambah',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CardStokHabis(size: querySize.size),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget kartuPemasukan() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 64, 190, 20),
            Color.fromARGB(255, 5, 120, 29),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Total Pemasukanmu',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  )),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: FutureBuilder(
                future: transaksi.getTotalPemasukkan(),
                initialData: transaksi.totalPemasukkan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      ),
                    );
                  }
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Rp ${current.format(transaksi.totalPemasukkan).substring(4)}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  );
                }),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white24),
          InkWell(
            onTap: () => Get.toNamed(RouteName.detail),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text('Lihat Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600,
                      )),
                  Spacer(),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
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
