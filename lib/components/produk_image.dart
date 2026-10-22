import 'dart:io';

import 'package:flutter/material.dart';

// Foto produk: path file lokal (paket offline) atau nama file/URL dari server.
ImageProvider produkImage(String? file, {String prefix = ''}) {
  if (file == null) return Image.asset('assets/img/bulog_toko_t.png').image;
  if (file.startsWith('/')) return FileImage(File(file));
  return Image.network('$prefix$file').image;
}
