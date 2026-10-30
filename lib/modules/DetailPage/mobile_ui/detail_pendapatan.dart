import 'package:tetrabit_toko_pos/modules/DetailPage/mobile_ui/components/income_per_pelanggan.dart';
import 'package:tetrabit_toko_pos/modules/DetailPage/mobile_ui/components/income_per_product.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../style/styles.dart';
import 'components/check_available_card.dart';
import 'components/history_payment_card.dart';
import 'components/monthly_income_card.dart';
import 'components/week_income_card.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String dateNow = DateFormat('y-MM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
        backgroundColor: AppColors.bgGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Detail Pendapatanmu',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        body: FutureBuilder<List>(
            future: getApiTransaksi.getApi(),
            initialData: getApiTransaksi.dataLaporan,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor, strokeWidth: 2),
                );
              }

              var data = snapshot.data ?? [];
              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async => setState(() {}),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    HistoryPaymentCard(data: data),
                    const SizedBox(height: 12),
                    CheckAvailableCard(data: data),
                    const SizedBox(height: 12),
                    MonthlyIncomeCard(dateNow: dateNow),
                    const SizedBox(height: 12),
                    IncomeProductCard(dateNow: dateNow),
                    const SizedBox(height: 12),
                    const WeekIncomeCard(),
                    const SizedBox(height: 12),
                    IncomePelangganCard(dateNow: dateNow),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
