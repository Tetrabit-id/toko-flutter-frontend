import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../models/cabang.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpSendStok extends StatefulWidget {
  const PopUpSendStok({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUpSendStok> createState() => _PopUpSendStokState();
}

class _PopUpSendStokState extends State<PopUpSendStok> {
  TextEditingController sendQtyStok = TextEditingController();
  late String sendCabangId = '';

  @override
  Widget build(BuildContext context) {
    List stokId = editStok.dataEditStok.map((e) => e.stokId).toList();
    List namaBarang = editStok.dataEditStok.map((e) => e.namaBarang).toList();
    List kodeBarang = editStok.dataEditStok.map((e) => e.kodeBarang).toList();
    List qty = editStok.dataEditStok.map((e) => e.qty).toList();

    editStok.editNmBrgC.text = namaBarang[0];
    editStok.editKodeBrgC.text = kodeBarang[0];
    editStok.editQtyC.text = qty[0];

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            'Barcode No.${editStok.editKodeBrgC.text}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'Nama Barang : ${editStok.editNmBrgC.text}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'Stok Tersedia : ${editStok.editQtyC.text}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          textFieldRoundedwithHint(
            'Qty',
            sendQtyStok,
            false,
            TextInputType.number,
            '0',
            TextAlign.start,
            size,
            4,
          ),
          const SizedBox(height: 5),
          DropdownSearch<Cabang>(
            dropdownBuilder: (context, selectedItem) => Text(
              selectedItem?.name.toString() ?? "Pilih Cabang Penyimpanan Stok",
              style: TextStyle(
                fontSize: 15,
                color: selectedItem?.name.toString() != null
                    ? Colors.black
                    : const Color.fromARGB(156, 0, 0, 0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                sendCabangId = value?.id ?? '';
              });
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.black),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: size.width / 20),
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                labelText: "Pilih Cabang",
                filled: true,
              ),
            ),
            clearButtonProps: const ClearButtonProps(isVisible: true),
            items: getApiCabang.dataCabangOwner.toList(),
            popupProps: PopupProps.modalBottomSheet(
              itemBuilder: (context, item, isSelected) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  title: Text('${item.name}'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => setState(() {
                if (sendQtyStok.text == '' || sendCabangId == '') {
                  snackbarNotif.unsuccess(
                      'Data Kosong', 'Mohon melengkapi data pengiriman');
                }

                postApiInsertPengiriman.connectAPI(
                  token.read('_id'),
                  sendCabangId,
                  stokId[0],
                  namaBarang[0],
                  kodeBarang[0],
                  int.parse(sendQtyStok.text),
                );

                getApiStok.getAPI(token.read('_id'), token.read('cabangId'));
              }),
              child: Container(
                  alignment: Alignment.center,
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Simpan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
