import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constructors/button_primary.dart';
import '../../../constructors/text_field_default.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

class AktivasiKodePage extends StatefulWidget {
  const AktivasiKodePage({super.key});

  @override
  State<AktivasiKodePage> createState() => _AktivasiKodePageState();
}

class _AktivasiKodePageState extends State<AktivasiKodePage> {
  final kodeC = TextEditingController();
  bool loading = false;

  Future<void> aktivasi() async {
    if (loading) return;
    if (kodeC.text.trim().isEmpty) {
      snackbarNotif.unsuccess('Kode Kosong', 'Masukkan kode aktivasi dari admin');
      return;
    }

    setState(() => loading = true);
    var success = await lisensi.activate(kodeC.text);
    if (!mounted) return;
    setState(() => loading = false);

    if (!success) return;
    Get.offAllNamed(RouteName.index);
    snackbarNotif.success('Paket offline aktif',
        'Pindah dari HP lama? Restore data lewat menu Backup & Restore');
  }

  @override
  void dispose() {
    kodeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          headerOne('Aktivasi Paket Offline'),
                          const SizedBox(height: 25),
                          paragraf(
                            'Masukkan kode aktivasi yang dikirim admin via WhatsApp. Kode hanya berlaku untuk 1 perangkat.',
                            TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    AppSvg.paymentInfoSvg,
                    const SizedBox(height: 40),
                    textFieldDefault('contoh: TKO-XXXX-XXXX', size, kodeC, false),
                    const SizedBox(height: 20),
                    buttonPrimaryWithLoading(
                        'Aktivasi',
                        AppColors.primaryColor,
                        Colors.white,
                        Colors.transparent,
                        Size(size.width - 100, size.height / 20),
                        loading,
                        aktivasi),
                    const SizedBox(height: 8),
                    buttonPrimary(
                        'Belum punya kode? Bayar',
                        Colors.white,
                        AppColors.colorFontPrimary,
                        AppColors.primaryColor,
                        Size(size.width - 100, size.height / 20),
                        () => Get.toNamed(RouteName.paymentDetail)),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => auth.logout(),
                      child: const Text('Keluar',
                          style: TextStyle(color: Colors.black45)),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
