import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:flutter/material.dart';

import '../../../style/styles.dart';
import 'laporan_invoice.dart';
import 'laporan_kasbon.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage>
    with SingleTickerProviderStateMixin {
  late TabController tabC;

  @override
  void initState() {
    tabC = TabController(vsync: this, length: 2);
    super.initState();
    transaksi.getTransaksiDateNow();
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
        data: querySize.copyWith(textScaleFactor: 0.81),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Laporan',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
            bottom: TabBar(
              controller: tabC,
              indicatorColor: AppColors.primaryColor,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black38,
              tabs: const [Tab(text: 'Invoice'), Tab(text: 'Kasbon')],
            ),
          ),
          body: TabBarView(
            controller: tabC,
            children: [
              InvoiceLaporan(size: querySize.size),
              InvoiceKasbon(size: querySize.size),
            ],
          ),
        ));
  }
}
