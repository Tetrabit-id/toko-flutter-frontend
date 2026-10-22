import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/styles.dart';

// Field pilih kategori/merk produk. Saat diketuk membuka bottom sheet
// berisi pencarian, tombol tambah, dan tombol hapus per item.
class PilihAtributField<T> extends StatelessWidget {
  const PilihAtributField({
    Key? key,
    required this.label,
    required this.items,
    required this.idOf,
    required this.nameOf,
    required this.selectedId,
    required this.onChanged,
    this.onAdd,
    this.onDelete,
  }) : super(key: key);

  final String label;
  final RxList<T> items;
  final String? Function(T item) idOf;
  final String? Function(T item) nameOf;
  final String selectedId;
  final ValueChanged<String> onChanged;
  final VoidCallback? onAdd;
  // null: tombol hapus disembunyikan. Mengembalikan true jika berhasil.
  final Future<bool> Function(T item)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var terpilih = items.firstWhereOrNull((e) => idOf(e) == selectedId);
      var nama = terpilih == null ? null : nameOf(terpilih);

      return InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => _AtributSheet<T>(field: this),
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Pilih $label',
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
          child: Text(
            nama ?? 'Pilih $label Produk',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: nama != null
                  ? Colors.black
                  : const Color.fromARGB(156, 0, 0, 0),
            ),
          ),
        ),
      );
    });
  }
}

class _AtributSheet<T> extends StatefulWidget {
  const _AtributSheet({Key? key, required this.field}) : super(key: key);

  final PilihAtributField<T> field;

  @override
  State<_AtributSheet<T>> createState() => _AtributSheetState<T>();
}

class _AtributSheetState<T> extends State<_AtributSheet<T>> {
  String cari = '';

  PilihAtributField<T> get f => widget.field;

  Future<void> hapus(T item) async {
    var nama = f.nameOf(item) ?? '';
    bool? yakin = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 26),
                ),
                const SizedBox(height: 14),
                Text('Hapus ${f.label}',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorFontPrimary,
                    )),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(children: [
                    const TextSpan(text: 'Yakin ingin menghapus '),
                    TextSpan(
                        text: nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorFontPrimary)),
                    const TextSpan(
                        text: '? Tindakan ini tidak bisa dibatalkan.'),
                  ]),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.colorFontPrimary,
                          side: const BorderSide(color: AppColors.borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (yakin != true) return;

    var berhasil = await f.onDelete!(item);
    if (berhasil && f.idOf(item) == f.selectedId) f.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.colorBgButton,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('Pilih ${f.label}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                if (f.onAdd != null)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      f.onAdd!();
                    },
                    icon: const Icon(Icons.add, color: AppColors.primaryColor),
                    label: const Text('Tambah',
                        style: TextStyle(color: AppColors.primaryColor)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              onChanged: (value) => setState(() => cari = value),
              decoration: InputDecoration(
                hintText: 'Cari ${f.label.toLowerCase()}',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: AppColors.bgGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height * 0.5),
            child: Obx(() {
              var data = f.items
                  .where((e) => (f.nameOf(e) ?? '')
                      .toLowerCase()
                      .contains(cari.toLowerCase()))
                  .toList();

              if (data.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  // Center akan memenuhi tinggi maksimal sheet, jadi pakai Align
                  child: Align(
                    heightFactor: 1,
                    child: Text(
                      cari.isEmpty
                          ? 'Belum ada ${f.label.toLowerCase()}'
                          : '${f.label} tidak ditemukan',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: data.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  var item = data[index];
                  var nama = f.nameOf(item) ?? '';
                  var dipilih = f.idOf(item) == f.selectedId;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    selected: dipilih,
                    selectedTileColor:
                        AppColors.primaryColor.withValues(alpha: 0.08),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.primaryColor.withValues(alpha: 0.15),
                      child: Text(
                        nama.isEmpty ? '?' : nama[0].toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(nama,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight:
                              dipilih ? FontWeight.w600 : FontWeight.normal,
                        )),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (dipilih)
                          const Icon(Icons.check_circle,
                              color: AppColors.primaryColor),
                        if (f.onDelete != null)
                          IconButton(
                            tooltip: 'Hapus',
                            onPressed: () => hapus(item),
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                          ),
                      ],
                    ),
                    onTap: () {
                      f.onChanged(f.idOf(item) ?? '');
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
