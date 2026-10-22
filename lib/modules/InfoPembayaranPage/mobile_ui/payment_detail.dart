import 'package:diatera_pos/constructors/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../style/styles.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    List dataText = [
      '1. Lakukan Transfer Bank dengan no.rek diatas.',
      '2. Setelah itu Screenshot/Foto bukti transfermu dan kirimkan dengan menekan tombol "Kirim Bukti Transfer" dibawah.',
      '3. Jika kamu "Pengguna Baru" mohon menekan tombol "Pengguna Baru", isi format yang telah disediakan sesuai data yang kamu registrasikan dalam aplikasi Toko dan kirimkan beserta bukti transfermu.',
      '4. Admin kami akan mengecek pembayaranmu dalam kurun waktu max.15 menit',
      '5. Jika telah dikonfirmasi, Admin akan memberikan waktu penggunaan aplikasi kepadamu dan aplikasi Toko-mu sudah bisa digunakan.'
    ];
    String noRek = '1234567890';
    String noWa = '6285892660932';
    String messageWa =
        'Hai%20Pengguna%20Baru,%20Yuk%20isi%20data%20dirimu%20dulu%0A%0ANama%20:%0AEmail%20:%0ANama%20Toko%20:%0AWilayah%20:%0A%0A*sertakan%20bukti%20pembayaranmu%20dibawah%20pesan%20ini%20ya%20;)';
    String nmRek = 'PT Diatera Cipta Teknologi';
    Size size = MediaQuery.of(context).size;
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaleFactor: 0.81),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Pembayaran Subscribe',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        body: Column(
          children: [
            Expanded(
              flex: Responsive.isMobile(context) ? 30 : 0,
              child: Container(
                width: size.width,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 64, 223, 7),
                      Color.fromARGB(255, 5, 135, 29)
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Paket Subsribe 30 hari',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset('assets/svg/payment_card.svg',
                            width: 105),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Input Stok Unlimited ✓',
                                style: TextStyle(color: Colors.white)),
                            Text('Tambah User/Karyawan Unlimited ✓',
                                style: TextStyle(color: Colors.white)),
                            Text('Connect to Printer Bluetooth ✓',
                                style: TextStyle(color: Colors.white)),
                            Text('Laporan Transaksi Payment ✓',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 5),
                            Text('100K / bulan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lato',
                                )),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        'Lifetime : 30 hari',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 70,
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: AppColors.bgGrey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 90),
                    ),
                  ],
                ),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 15),
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 10,
                        right: 0,
                      ),
                      width: size.width,
                      height: Responsive.isMobile(context)
                          ? size.height / 12
                          : size.height / 6,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/img/logo_bca.png'),
                                      fit: BoxFit.contain,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.white,
                                        Colors.grey.shade300,
                                      ],
                                    )),
                              ),
                              const SizedBox(width: 8),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BCA',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Transfer Bank',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    nmRek,
                                  ),
                                  Text(
                                    'No.Rek $noRek',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                  onPressed: () => Clipboard.setData(
                                              ClipboardData(text: noRek))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                content: Text(
                                                    "No.Rek copied to clipboard")));
                                      }),
                                  child: const Text(
                                    'Salin',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 5, right: 15, left: 15),
                      child: Text(
                        'Cara Bayar :',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height / 3,
                      child: ListView.builder(
                        physics: const ScrollPhysics(
                            parent: NeverScrollableScrollPhysics()),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        itemCount: 5,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(dataText[index]),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttonPrimary(
                            'Kirim Bukti Transfer',
                            AppColors.primaryColor,
                            Colors.white,
                            Colors.transparent,
                            Size(size.width / 2.2, size.height / 20), () async {
                          final Uri url =
                              Uri.parse('whatsapp://send?phone=$noWa');
                          if (!await launchUrl(url,
                              mode: LaunchMode.platformDefault)) {
                            throw 'Could not launch $url';
                          }
                        }),
                        buttonPrimary(
                            'Pengguna Baru',
                            Colors.white,
                            AppColors.primaryColor,
                            AppColors.primaryColor,
                            Size(size.width / 2.5, size.height / 20), () async {
                          final Uri url = Uri.parse(
                              'whatsapp://send?phone=$noWa&text=$messageWa');
                          if (!await launchUrl(url,
                              mode: LaunchMode.platformDefault)) {
                            throw 'Could not launch $url';
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
