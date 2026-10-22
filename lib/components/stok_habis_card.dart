import 'package:flutter/material.dart';

import '../routes/base_url.dart';
import '../routes/state_global.dart';
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
            return const LoadingCilcular();
          }

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                width: size.width,
                height: snapshot.data!.isEmpty ? 210 : 385,
                child: snapshot.data!.isEmpty
                    ? const Center(
                        child: Text(
                          'Stok masih tersedia. Tidak ada stok yang habis.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.grey, height: 25),
                        itemBuilder: (context, index) =>
                            StokCard(index: index, dataStok: snapshot.data!)),
              ));
        });
  }
}
