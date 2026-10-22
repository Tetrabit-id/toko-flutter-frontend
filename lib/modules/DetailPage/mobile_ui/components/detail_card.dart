import 'package:flutter/material.dart';

import '../../../../style/styles.dart';

const namaBulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

// "2026-10" -> "Oktober 2026"
String labelBulan(String bulan) {
  var bagian = bulan.split('-');
  return '${namaBulan[int.parse(bagian[1]) - 1]} ${bagian[0]}';
}

// Kartu putih dengan ikon & judul, dipakai semua bagian halaman detail
class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// Baris peringkat: nomor/inisial, nama, keterangan, nilai, dan bar proporsi
class BarisPeringkat extends StatelessWidget {
  const BarisPeringkat({
    super.key,
    required this.leading,
    required this.nama,
    required this.keterangan,
    required this.nilai,
    required this.proporsi,
  });

  final String leading;
  final String nama;
  final String keterangan;
  final num nilai;
  final double proporsi;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
              child: Text(leading,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(keterangan,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Text(current.format(nilai),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: proporsi.clamp(0, 1),
            minHeight: 6,
            backgroundColor: AppColors.bgGrey,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class KosongDetail extends StatelessWidget {
  const KosongDetail({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 32),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class LoadingDetail extends StatelessWidget {
  const LoadingDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              color: AppColors.primaryColor, strokeWidth: 2),
        ),
      ),
    );
  }
}
