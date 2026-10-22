import 'package:diatera_pos/models/cabang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/state_global.dart';
import '../style/styles.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key, this.index = 0}) : super(key: key);
  final int index;

  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Cabang? cabang =
        getApiCabang.getCabangById(karyawan.foundUser[index]['cabangId']);

    return Container(
      width: size.width,
      height: Responsive.isMobile(context) ? size.height / 11 : size.height / 5,
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
            flex: 65,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(karyawan.foundUser[index]['name'])}',
                      style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${karyawan.foundUser[index]['email']}',
                      style: const TextStyle(fontFamily: 'Lato'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${cabang?.name}',
                      style: const TextStyle(fontFamily: 'Lato'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 20,
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
                    '${karyawan.foundUser[index]['role'].toString().capitalizeFirst}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                karyawan.foundUser[index]['role'] == 'admin'
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () => karyawan.delete(
                              karyawan.foundUser[index]['_id'].toString(),
                            ),
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
