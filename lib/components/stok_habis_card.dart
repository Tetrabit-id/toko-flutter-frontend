import 'package:flutter/material.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';
import 'loading_cilcular.dart';
import 'stok_card.dart';

class CardStokHabis extends StatelessWidget {
  const CardStokHabis({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: stok.getOutStok(token.read('_id'), token.read('cabangId')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 120, child: LoadingCilcular());
          }
          List dataStok = snapshot.data ?? [];

          if (dataStok.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: AppColors.primaryColor, size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text('Semua stok aman',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  const Text('Tidak ada stok yang habis.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              height: 385,
              child: ListView.separated(
                  itemCount: dataStok.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: AppColors.colorBgButton, height: 25),
                  itemBuilder: (context, index) =>
                      StokCard(index: index, dataStok: dataStok)),
            ),
          );
        });
  }
}
