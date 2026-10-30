import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Foto produk: path file lokal (paket offline), data URI (paket offline di
// web), atau nama file/URL dari server.
ImageProvider produkImage(String? file, {String prefix = ''}) {
  if (file == null) return Image.asset('assets/img/bulog_toko_t.png').image;
  if (file.startsWith('data:')) {
    return MemoryImage(UriData.parse(file).contentAsBytes());
  }
  if (file.startsWith('/')) {
    // Web tidak bisa membaca file lokal
    if (kIsWeb) return Image.asset('assets/img/bulog_toko_t.png').image;
    return FileImage(File(file));
  }
  return Image.network('$prefix$file').image;
}
