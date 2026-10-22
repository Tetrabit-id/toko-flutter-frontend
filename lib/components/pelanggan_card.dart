import 'package:flutter/material.dart';

import '../routes/state_global.dart';
import '../style/styles.dart';

class PelangganCard extends StatelessWidget {
  const PelangganCard({Key? key, this.index = 0}) : super(key: key);
  final int index;

  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: Responsive.isMobile(context) ? size.height / 9 : size.height / 3,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Expanded(
          //     flex: 15, child: CircleAvatar(backgroundColor: Colors.black)),
          const SizedBox(width: 10),
          Expanded(
            flex: 60,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pelanggan.foundPelanggan[index]['name']
                                  .toString()
                                  .length >
                              16
                          ? '${pelanggan.foundPelanggan[index]['name'].toString().substring(0, 14)}..'
                          : pelanggan.foundPelanggan[index]['name'].toString(),
                      style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'ID : ${pelanggan.foundPelanggan[index]['memberId']}',
                      style: const TextStyle(fontFamily: 'Lato'),
                    ),
                    Text(
                      '${pelanggan.foundPelanggan[index]['email']}',
                      style: const TextStyle(fontFamily: 'Lato'),
                    ),
                    Text(
                      '${pelanggan.foundPelanggan[index]['phone']}',
                      style: const TextStyle(fontFamily: 'Lato'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width,
                  height: 20,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'NIK: ${pelanggan.foundPelanggan[index]['nik']}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Poin Member ${pelanggan.foundPelanggan[index]['poin']}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato'),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                    onTap: () => pelanggan.delete(
                        pelanggan.foundPelanggan[index]['_id'].toString()),
                    child: const Icon(
                      Icons.delete_rounded,
                      size: 18,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
