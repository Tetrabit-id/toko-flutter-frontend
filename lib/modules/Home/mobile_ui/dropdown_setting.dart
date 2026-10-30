import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/state_global.dart';

class DropdownSetting extends StatelessWidget {
  const DropdownSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    return MediaQuery(
      data: querySize.copyWith(textScaler: const TextScaler.linear(0.81)),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 5, top: 4, bottom: 4),
        child: PopupMenuButton(
            padding: const EdgeInsets.all(4),
            icon: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 40,
                  height: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/img/logo_toko_t.png'),
                    fit: BoxFit.cover,
                  )),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_drop_down_circle, size: 15),
                    ],
                  ),
                )),
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () => auth.editAkun(),
                      child: const Row(
                        children: [
                          Icon(Icons.person, color: Colors.black),
                          SizedBox(width: 5),
                          Text('Akun', style: TextStyle(color: Colors.black87))
                        ],
                      )),
                  if (paket.canChat)
                  PopupMenuItem(
                      onTap: () async {
                        await getApiUsersK.getApi();
                        Get.toNamed(RouteName.obrolan);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.chat_rounded, color: Colors.black),
                          SizedBox(width: 5),
                          Text('Obrolan',
                              style: TextStyle(color: Colors.black87))
                        ],
                      )),
                  PopupMenuItem(
                      onTap: () async {
                        await getApiPelanggan.getApi();
                        Get.toNamed(RouteName.pelanggan);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.card_membership, color: Colors.black),
                          SizedBox(width: 5),
                          Text('Pelanggan',
                              style: TextStyle(color: Colors.black87))
                        ],
                      )),
                  PopupMenuItem(
                      onTap: () async {
                        await getApiPelanggan.getApi();
                        Get.toNamed(RouteName.rekapKas);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.account_balance_rounded,
                              color: Colors.black),
                          SizedBox(width: 5),
                          Text('Rekap Kas',
                              style: TextStyle(color: Colors.black87))
                        ],
                      )),
                  // Paket offline: data hanya di HP, perlu backup
                  if (paket.isOffline)
                    PopupMenuItem(
                        onTap: () => Get.toNamed(RouteName.backup),
                        child: const Row(
                          children: [
                            Icon(Icons.backup, color: Colors.black),
                            SizedBox(width: 5),
                            Text('Backup & Restore',
                                style: TextStyle(color: Colors.black87))
                          ],
                        )),
                  PopupMenuItem(
                      onTap: () => printer.getDevices(),
                      child: const Row(
                        children: [
                          Icon(Icons.print, color: Colors.black),
                          SizedBox(width: 5),
                          Text('Printer',
                              style: TextStyle(color: Colors.black87))
                        ],
                      )),
                  PopupMenuItem(
                      onTap: () => auth.logout(),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.black),
                          SizedBox(width: 5),
                          Text('Keluar',
                              style: TextStyle(color: Colors.black87))
                        ],
                      )),
                ]),
      ),
    );
  }
}
