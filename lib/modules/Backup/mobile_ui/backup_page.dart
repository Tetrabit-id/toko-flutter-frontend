// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constructors/button_primary.dart';
import '../../../constructors/text_style.dart';
import '../../../routes/base_url.dart';
import '../../../routes/route.dart';
import '../../../routes/state_global.dart';
import '../../../style/styles.dart';

// Paket offline: data hanya ada di HP, jadi backup dibagikan ke WA / Drive
// dan di-restore di HP baru setelah aktivasi.
class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool loadingBackup = false;
  bool loadingRestore = false;

  Future<void> backup() async {
    if (loadingBackup) return;
    setState(() => loadingBackup = true);
    try {
      var file = await localBackup.export();
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        text: 'Backup data ${token.read('store') ?? 'Toko'}',
      ));
    } catch (e) {
      print(e);
      snackbarNotif.unsuccess('Backup gagal', '$e');
    }
    if (mounted) setState(() => loadingBackup = false);
  }

  Future<void> restore() async {
    if (loadingRestore) return;
    var lanjut = await Get.defaultDialog<bool>(
      title: 'Restore Backup',
      middleText:
          'Semua data di HP ini (produk, stok, transaksi, pelanggan, kasbon, rekap kas) akan diganti dengan isi backup. Lanjutkan?',
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textConfirm: 'Restore',
      textCancel: 'Batal',
      buttonColor: Colors.white,
      confirmTextColor: Colors.red,
      cancelTextColor: Colors.black45,
      onConfirm: () => Get.back(result: true),
    );
    if (lanjut != true) return;

    var files = await FilePicker.pickFiles(dialogTitle: 'Pilih file backup');
    var path = files.isEmpty ? null : files.single.path;
    if (path == null) return;

    setState(() => loadingRestore = true);
    var error = await localBackup.restore(File(path));
    if (!mounted) return;
    setState(() => loadingRestore = false);

    if (error != null) {
      snackbarNotif.unsuccess('Restore gagal', error);
      return;
    }
    snackbarNotif.success('Restore berhasil', 'Data dari backup sudah dipulihkan');
    Get.offAllNamed(RouteName.index);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    String? lastBackup = token.read('lastBackup');
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Backup & Restore',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: AppColors.primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lastBackup == null
                            ? 'Belum pernah backup'
                            : 'Backup terakhir: ${dateFormat(lastBackup)}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              paragraf(
                'Paket offline menyimpan data hanya di HP ini. Buat backup secara rutin dan simpan ke WhatsApp, Google Drive, atau email agar data tidak hilang saat HP rusak atau ganti HP.',
                TextAlign.center,
              ),
              const SizedBox(height: 30),
              buttonPrimaryWithLoading(
                'Buat & Bagikan Backup',
                AppColors.primaryColor,
                Colors.white,
                Colors.transparent,
                Size(size.width - 60, size.height / 20),
                loadingBackup,
                backup,
              ),
              const SizedBox(height: 40),
              paragrafSecond(
                'Pindah HP? Login, masukkan kode aktivasi, lalu restore file backup dari HP lama di sini.',
                TextAlign.center,
              ),
              const SizedBox(height: 15),
              buttonPrimaryWithLoading(
                'Restore dari File',
                Colors.white,
                AppColors.colorFontPrimary,
                AppColors.primaryColor,
                Size(size.width - 60, size.height / 20),
                loadingRestore,
                restore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
