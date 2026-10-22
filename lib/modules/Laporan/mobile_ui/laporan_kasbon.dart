import 'package:flutter/material.dart';

import '../../../components/laporan_kasbon_card.dart';
import '../../../components/loading_cilcular.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class InvoiceKasbon extends StatelessWidget {
  const InvoiceKasbon({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getApiKasbon.getApi(),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Container(
            width: size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 3))
              ],
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.switch_access_shortcut_sharp,
                            color: AppColors.primaryColor,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text('Total Kasbon',
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Text(dateFormat(DateTime.now().toString()),
                          style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w300))
                    ],
                  ),
                  const SizedBox(height: 5),
                  FutureBuilder(
                      future: transaksi.getPemasukanHariIni(
                          dateFormat(DateTime.now().toString())),
                      initialData: transaksi.pendapatanHariIni,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingCilcular();
                        }
                        return Text(current.format(0),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold));
                      }),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15, left: 15, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kasbon',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  Icon(
                    Icons.assignment_rounded,
                    color: AppColors.primaryColor,
                  )
                ]),
          ),
          FutureBuilder<List>(
              future: getApiKasbon.getApi(),
              initialData: getApiKasbon.dataKasbon,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return SizedBox(
                    height: size.height / 1.7,
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor, strokeWidth: 2)),
                  );
                }
                List listKasbon = snapshot.data!;

                return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: listKasbon.isEmpty
                        ? SizedBox(
                            height: size.height / 1.7,
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppSvg.notFoundLaporanSvg,
                                    const SizedBox(height: 25),
                                    headerNotFound('Kasbon hari ini tidak ada'),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listKasbon.length,
                            itemBuilder: (context, index) {
                              return LaporanKasbonCard(
                                index: index,
                                dataKasbon: listKasbon,
                              );
                            }));
              }),
        ],
      ),
    );
  }
}
