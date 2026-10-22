import 'package:tetrabit_toko_pos/routes/base_url.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constructors/text_field_rounded.dart';
import '../models/kategori.dart';
import '../models/merk.dart';
import '../routes/state_global.dart';
import '../style/styles.dart';

class PopUpStok extends StatefulWidget {
  const PopUpStok({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUpStok> createState() => _PopUpStokState();
}

class _PopUpStokState extends State<PopUpStok> {
  @override
  Widget build(BuildContext context) {
    List stokId = editStok.dataEditStok.map((e) => e.stokId).toList();
    List produkId = editStok.dataEditStok.map((e) => e.produkId).toList();
    List cabangId = editStok.dataEditStok.map((e) => e.cabangId).toList();
    List namaBarang = editStok.dataEditStok.map((e) => e.namaBarang).toList();
    List kodeBarang = editStok.dataEditStok.map((e) => e.kodeBarang).toList();
    List hargaBarang = editStok.dataEditStok.map((e) => e.hargaBarang).toList();
    List hargaBeli = editStok.dataEditStok.map((e) => e.hargaBeli).toList();
    List qty = editStok.dataEditStok.map((e) => e.qty).toList();
    List satuan = editStok.dataEditStok.map((e) => e.satuan).toList();

    editStok.editNmBrgC.text = namaBarang[0];
    editStok.editKodeBrgC.text = kodeBarang[0];
    editStok.editHrgC.text = hargaBarang[0];
    editStok.editQtyC.text = qty[0];
    editStok.editStnC.text = satuan[0];
    editStok.editHrgBeliC.text = hargaBeli[0];

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
          textFieldRounded(
            'Nama Barang',
            editStok.editNmBrgC,
            false,
            TextInputType.text,
            false,
            size,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 20,
                child: textFieldRoundedwithHint(
                  'Qty',
                  editStok.editQtyC,
                  false,
                  TextInputType.number,
                  '0',
                  TextAlign.center,
                  size,
                  4,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  flex: 60, child: dropDownSatuan(size, editStok.editStnC)),
            ],
          ),
          textFieldRoundedCurrentwithHint(
            'Harga Jual per satuan',
            editStok.editHrgC,
            false,
            TextInputType.number,
            'Rp.',
            TextAlign.start,
            size,
          ),
          textFieldRoundedCurrentwithHint(
            'Harga Beli per satuan',
            editStok.editHrgBeliC,
            false,
            TextInputType.number,
            'Rp.',
            TextAlign.start,
            size,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => editStok.delete(stokId[0], produkId[0]),
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  var idOwner = token.read('role') != 'admin'
                      ? token.read('parentId')
                      : token.read('_id');

                  putApiUpdateProduk.connectAPI(
                    stokId[0],
                    idOwner,
                    cabangId[0],
                    produkId[0],
                    editStok.editNmBrgC.text,
                    int.parse(editStok.editQtyC.text),
                    editStok.editSatuan.value,
                    int.parse(editStok.editHrgC.text
                        .substring(4)
                        .replaceAll(',', '')),
                    int.parse(editStok.editHrgBeliC.text
                        .substring(4)
                        .replaceAll(',', '')),
                  );

                  getApiStok.getAPI(idOwner, token.read('cabangId'));
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
            ],
          )
        ],
      ),
    );
  }

  DropdownSearch<String> dropDownSatuan(
      Size size, TextEditingController satuan) {
    return DropdownSearch<String>(
      items: const ["pcs", "g", "kg", "ons", "liter", "karung"],
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          labelText: "Pilih Satuan",
          filled: true,
        ),
      ),
      selectedItem: satuan.text,
      onChanged: (value) {
        setState(() {
          editStok.editSatuan.value = value ?? '';
        });
      },
    );
  }

  DropdownSearch<Merk> dropDownMerk(Size size) {
    return DropdownSearch<Merk>(
      dropdownBuilder: (context, selectedItem) => Text(
        selectedItem?.name.toString() ?? "Pilih Merk Produk",
        style: TextStyle(
          fontSize: 15,
          color: selectedItem?.name.toString() != null
              ? Colors.black
              : const Color.fromARGB(156, 0, 0, 0),
        ),
      ),
      onChanged: (value) {
        setState(() {
          stok.merkIdPrdC = value?.id ?? '';
        });
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          labelText: "Pilih Merk",
          filled: true,
        ),
      ),
      clearButtonProps: const ClearButtonProps(isVisible: true),
      items: getApiMerkProduk.dataMerkProduk.toList(),
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            title: Text('${item.name}'),
          ),
        ),
      ),
    );
  }

  DropdownSearch<Kategori> dropDownKategori(Size size) {
    return DropdownSearch<Kategori>(
      dropdownBuilder: (context, selectedItem) => Text(
        selectedItem?.name.toString() ?? "Pilih Kategori Produk",
        style: TextStyle(
          fontSize: 15,
          color: selectedItem?.name.toString() != null
              ? Colors.black
              : const Color.fromARGB(156, 0, 0, 0),
        ),
      ),
      onChanged: (value) {
        setState(() {
          stok.kategoriIdPrdC = value?.id ?? '';
        });
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(horizontal: size.width / 20),
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          labelText: "Pilih Kategori",
          filled: true,
        ),
      ),
      clearButtonProps: const ClearButtonProps(isVisible: true),
      items: getApiKategoriProduk.dataKategoriProduk.toList(),
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            title: Text('${item.name}'),
          ),
        ),
      ),
    );
  }
}
