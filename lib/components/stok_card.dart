import 'package:tetrabit_toko_pos/components/send_stok_popup.dart';
import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';
import 'edit_stok_popup.dart';
import 'produk_image.dart';

class StokCard extends StatelessWidget {
  const StokCard({Key? key, this.index = 0, required this.dataStok})
      : super(key: key);
  final int index;
  final List dataStok;

  @override
  Row build(BuildContext context) {
    var image = dataStok[index]['produk'] == null
        ? null
        : dataStok[index]['produk']['file'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 5,
          height: 50,
          color: (dataStok[index]['qty'] >= 0)
              ? AppColors.primaryColor
              : Colors.red,
        ),
        const SizedBox(width: 10),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: produkImage(image, prefix: '$baseUrl/files/')),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 80,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dataStok[index]['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      )),
                  Text('${dataStok[index]['qty']} ${dataStok[index]['satuan']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Barcode: #${dataStok[index]['code']}',
                      style: const TextStyle(fontSize: 13)),
                  Text(
                    '${current.format(dataStok[index]['harga'])} / ${dataStok[index]['satuan']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  )
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Container(
              width: 1,
              height: 40,
              color: AppColors.borderColor,
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                editStok.dataEditStok.clear();
                var list = dataStok[index];
                editStok.addEditStok(
                  list['_id'],
                  list['cabangId'],
                  list['produkId'],
                  list['code'],
                  list['name'],
                  list['qty'].toString(),
                  list['satuan'],
                  current.format(list['harga']),
                  current.format(list['hargaModal']),
                );
                Get.defaultDialog(
                  title: 'Edit Stok',
                  titlePadding: const EdgeInsets.only(top: 20),
                  content: const PopUpStok(),
                );
              },
              child: const SizedBox(
                width: 30,
                height: 40,
                child: Icon(Icons.edit, size: 18),
              ),
            )
          ],
        )
      ],
    );
  }
}

class FilterStokCard extends StatelessWidget {
  const FilterStokCard({Key? key, this.index = 0, required this.role})
      : super(key: key);
  final int index;
  final String role;

  Future<void> sendStok(int i) async {
    await token.read('_id');
    editStok.dataEditStok.clear();
    var list = stok.foundStok[i];
    editStok.addEditStok(
      list['_id'],
      list['cabangId'],
      list['produkId'],
      list['code'],
      list['name'],
      list['qty'].toString(),
      list['satuan'],
      current.format(list['harga']),
      current.format(list['hargaModal']),
    );
    return Get.defaultDialog(
      title: 'Kirim Stok',
      titlePadding: const EdgeInsets.only(top: 20),
      content: const PopUpSendStok(),
    );
  }

  Future<void> editItem(int i) async {
    await token.read('_id');
    editStok.dataEditStok.clear();
    var list = stok.foundStok[i];
    editStok.addEditStok(
      list['_id'],
      list['cabangId'],
      list['produkId'],
      list['code'],
      list['name'],
      list['qty'].toString(),
      list['satuan'],
      current.format(list['harga']),
      current.format(list['hargaModal']),
    );
    return Get.defaultDialog(
      title: 'Edit Stok',
      titlePadding: const EdgeInsets.only(top: 20),
      content: const PopUpStok(),
    );
  }

  @override
  Row build(BuildContext context) {
    var image = stok.foundStok[index]['produk'] == null
        ? null
        : stok.foundStok[index]['produk']['file'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 5,
          height: 45,
          color: stok.foundStok[index]['qty'] >= 0
              ? AppColors.primaryColor
              : Colors.red,
        ),
        const SizedBox(width: 8),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: produkImage(image)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 80,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${stok.foundStok[index]['name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      )),
                  Text(
                      '${stok.foundStok[index]['qty']} ${stok.foundStok[index]['satuan']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Barcode: #${stok.foundStok[index]['code']}',
                      style: const TextStyle(fontSize: 13)),
                  Text(
                    '${current.format(stok.foundStok[index]['harga'])} / ${stok.foundStok[index]['satuan']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  )
                ],
              ),
            ],
          ),
        ),
        role == 'Kasir'
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.borderColor,
                  ),
                  PopupMenuButton(
                    padding: const EdgeInsets.all(0),
                    icon: const SizedBox(
                      width: 5,
                      height: 40,
                      child: Icon(Icons.more_vert_rounded, size: 18),
                    ),
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    itemBuilder: (context) => [
                      if (paket.canKirimStok)
                      PopupMenuItem(
                          onTap: () => token.read('role') != 'admin'
                              ? null
                              : sendStok(index),
                          child: Row(
                            children: [
                              Icon(Icons.send_rounded,
                                  color: token.read('role') != 'admin'
                                      ? Colors.grey
                                      : Colors.black),
                              const SizedBox(width: 5),
                              Text('Kirim',
                                  style: TextStyle(
                                      color: token.read('role') != 'admin'
                                          ? Colors.grey
                                          : Colors.black87))
                            ],
                          )),
                      PopupMenuItem(
                          onTap: () => editItem(index),
                          child: const Row(
                            children: [
                              Icon(Icons.edit, color: Colors.black),
                              SizedBox(width: 5),
                              Text('Edit',
                                  style: TextStyle(color: Colors.black87))
                            ],
                          )),
                      PopupMenuItem(
                          onTap: () async {
                            await token.read('_id');
                            editStok.delete(
                              stok.foundStok[index]['_id'],
                              stok.foundStok[index]['produkId'],
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: Colors.black),
                              SizedBox(width: 5),
                              Text('Delete',
                                  style: TextStyle(color: Colors.black87))
                            ],
                          )),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}
