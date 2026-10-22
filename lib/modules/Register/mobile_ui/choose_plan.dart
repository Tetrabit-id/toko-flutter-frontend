import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../services/plan_service.dart';
import '../../../style/styles.dart';

class ChoosePlanPage extends StatelessWidget {
  const ChoosePlanPage({super.key});

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
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: AppImages.logoFull,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              Center(
                // Lebar dibatasi agar tetap rapi di tablet & web
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Transform.translate(
                    offset: const Offset(0, -40),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          PlanCard(info: planSubscription),
                          SizedBox(height: 16),
                          PlanCard(info: planOffline),
                          SizedBox(height: 16),
                          _CatatanAktivasi(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.storefront_rounded,
                    size: 16, color: AppColors.primaryColor),
                SizedBox(width: 6),
                Text('Daftar Akun Baru',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          headerOne('Pilih Paket'),
          const SizedBox(height: 6),
          const Text(
            'Pilih paket yang sesuai dengan kebutuhan tokomu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Lato',
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.info});
  final PlanInfo info;

  bool get unggulan => info.plan == AppPlan.subscription;

  void pilih() {
    postApiRegisterO.plan = info.value;
    Get.toNamed(RouteName.signUpMobile);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = unggulan ? Colors.white : AppColors.colorFontPrimary;
    final subColor = unggulan ? Colors.white70 : Colors.black54;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: unggulan
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 64, 190, 20),
                    Color.fromARGB(255, 5, 120, 29),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: unggulan ? null : Colors.white,
          border: unggulan
              ? null
              : Border.all(color: const Color.fromARGB(255, 225, 225, 225)),
          boxShadow: [
            BoxShadow(
              color: unggulan
                  ? AppColors.primaryColor.withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: pilih,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: unggulan
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        unggulan
                            ? Icons.cloud_sync_rounded
                            : Icons.wifi_off_rounded,
                        color: unggulan ? Colors.white : AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(info.nama,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lato',
                              )),
                          const SizedBox(height: 2),
                          Text(
                            unggulan
                                ? 'Online, multi cabang & karyawan'
                                : 'Tanpa internet, 1 perangkat',
                            style: TextStyle(color: subColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (unggulan)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Paling Lengkap',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                _Harga(harga: info.harga, color: textColor, subColor: subColor),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: subColor),
                    const SizedBox(width: 4),
                    Text(info.masaAktif,
                        style: TextStyle(color: subColor, fontSize: 12)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    height: 1,
                    color: unggulan
                        ? Colors.white24
                        : const Color.fromARGB(255, 235, 235, 235),
                  ),
                ),
                ...info.fitur.map((fitur) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 18,
                              color: unggulan
                                  ? Colors.white
                                  : AppColors.primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(fitur,
                                style:
                                    TextStyle(color: textColor, fontSize: 14)),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: pilih,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                          unggulan ? Colors.white : AppColors.primaryColor,
                      foregroundColor:
                          unggulan ? AppColors.primaryColor : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pilih ${info.nama}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Lato',
                            )),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// "100K / bulan": angka dibuat besar, periodenya kecil
class _Harga extends StatelessWidget {
  const _Harga({
    required this.harga,
    required this.color,
    required this.subColor,
  });

  final String harga;
  final Color color;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    var bagian = harga.split('/');
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: bagian.first.trim(),
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            fontFamily: 'Lato',
          ),
        ),
        if (bagian.length > 1)
          TextSpan(
            text: ' / ${bagian.sublist(1).join('/').trim()}',
            style: TextStyle(color: subColor, fontSize: 14),
          ),
      ]),
    );
  }
}

class _CatatanAktivasi extends StatelessWidget {
  const _CatatanAktivasi();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 225, 225, 225)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 20, color: AppColors.primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Paket Offline diaktifkan dengan kode aktivasi dari admin dan '
              'hanya berlaku di 1 perangkat.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
