import 'package:flutter/material.dart';

import '../../../../routes/base_url.dart';
import '../../../../routes/state_global.dart';

class CheckAvailableCard extends StatelessWidget {
  const CheckAvailableCard({super.key, required this.data});

  final List data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Statistik(
            icon: Icons.receipt_long_rounded,
            color: const Color.fromARGB(255, 7, 133, 223),
            label: 'Transaksi',
            jumlah: Future.value(data),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Statistik(
            icon: Icons.remove_shopping_cart_rounded,
            color: const Color.fromARGB(255, 240, 60, 90),
            label: 'Stok Habis',
            jumlah: stok.getOutStok(token.read('_id'), token.read('cabangId')),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Statistik(
            icon: Icons.inventory_2_rounded,
            color: const Color.fromARGB(255, 5, 150, 29),
            label: 'Stok Tersedia',
            jumlah: stok.getAvailableStok(
                token.read('_id'), token.read('cabangId')),
          ),
        ),
      ],
    );
  }
}

class _Statistik extends StatelessWidget {
  const _Statistik({
    required this.icon,
    required this.color,
    required this.label,
    required this.jumlah,
  });

  final IconData icon;
  final Color color;
  final String label;
  final Future<List> jumlah;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List>(
            future: jumlah,
            builder: (context, snapshot) => Text(
              snapshot.hasData ? '${snapshot.data!.length}' : '-',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                color: Colors.black54,
              )),
        ],
      ),
    );
  }
}
