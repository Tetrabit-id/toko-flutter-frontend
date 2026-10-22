import 'dart:convert';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../routes/base_url.dart';

// Database lokal (SQLite).
// - Paket offline: data utama toko.
// - Paket subscription: cache data server + antrean (outbox) saat offline.
// Nama kolom sengaja sama dengan field JSON dari API, sehingga hasil query
// bisa langsung dipakai UI yang sama seperti data dari server.
// Kolom `_id` (UUID dibuat di HP) juga jadi idempotency key saat data di-sync.
class LocalDb extends GetxController {
  Database? _db;
  String? _dbUserId;

  // Satu file DB per akun, agar data dua akun di HP yang sama tidak tercampur.
  Future<Database> get db async {
    String userId = token.read('_id') ?? 'guest';
    if (_db != null && _dbUserId == userId) return _db!;

    await _db?.close();
    _dbUserId = userId;
    return _db = await openDatabase(
      join(await getDatabasesPath(), 'toko_offline_$userId.db'),
      version: 2,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await _create(db, version);
        await _upgradeV2(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _upgradeV2(db);
      },
    );
  }

  // Simpan data dari server sebagai cache (paket subscription), agar kasir
  // tetap jalan saat offline. Baris yang dibuat offline (pending = 1) tidak
  // ikut terhapus; hanya kolom yang ada di tabel yang disimpan.
  Future<void> replaceCache(
    String table,
    List rows, {
    String where = 'pending = 0',
    List<Object?>? whereArgs,
  }) async {
    var database = await db;
    var columns = (await database.rawQuery('PRAGMA table_info($table)'))
        .map((c) => c['name'] as String)
        .toList();

    await database.transaction((txn) async {
      await txn.delete(table, where: where, whereArgs: whereArgs);
      var batch = txn.batch();
      for (Map row in rows) {
        batch.insert(
          table,
          {
            for (var c in columns)
              if (row.containsKey(c)) c: _sqlValue(row[c]),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Object? _sqlValue(dynamic value) {
    if (value == null || value is num || value is String) return value;
    if (value is bool) return value ? 1 : 0;
    return jsonEncode(value);
  }

  // v2: dukungan offline-first paket subscription
  // - pending = 1: dibuat saat offline, menunggu dikirim ke server
  // - syncError: alasan jika ditolak server
  // - stok.produkJson: objek `produk` dari server (cache)
  // - stok tanpa foreign key ke produk, karena cache stok server tidak punya
  //   baris produk lokal (hapus stok saat produk dihapus dilakukan manual)
  Future<void> _upgradeV2(Database db) async {
    var batch = db.batch();
    batch.execute('''
      CREATE TABLE stok_v2 (
        _id TEXT PRIMARY KEY, userId TEXT, cabangId TEXT, produkId TEXT,
        produkKategoriId TEXT, produkMerkId TEXT, name TEXT, code TEXT,
        qty INTEGER, satuan TEXT, harga INTEGER, hargaModal INTEGER,
        createdAt TEXT, updatedAt TEXT, produkJson TEXT
      )''');
    batch.execute('''
      INSERT INTO stok_v2 (_id, userId, cabangId, produkId, produkKategoriId,
        produkMerkId, name, code, qty, satuan, harga, hargaModal, createdAt,
        updatedAt)
      SELECT _id, userId, cabangId, produkId, produkKategoriId, produkMerkId,
        name, code, qty, satuan, harga, hargaModal, createdAt, updatedAt
      FROM stok''');
    batch.execute('DROP TABLE stok');
    batch.execute('ALTER TABLE stok_v2 RENAME TO stok');
    batch.execute('CREATE INDEX stok_produk ON stok(produkId)');
    for (var table in ['memberships', 'transaksi', 'kasbon', 'rekap_kas']) {
      batch.execute(
          'ALTER TABLE $table ADD COLUMN pending INTEGER NOT NULL DEFAULT 0');
      batch.execute('ALTER TABLE $table ADD COLUMN syncError TEXT');
    }
    batch.execute('ALTER TABLE transaksi ADD COLUMN membershipsId TEXT');
    batch.execute('ALTER TABLE transaksi ADD COLUMN memberId TEXT');
    await batch.commit(noResult: true);
  }

  String newId() => const Uuid().v4();

  String now() => DateTime.now().toIso8601String();

  // Paket offline hanya punya cabang Pusat
  String get cabangId => token.read('cabangId') ?? 'pusat';

  Future<void> _create(Database db, int version) async {
    var batch = db.batch();
    batch.execute('''
      CREATE TABLE produk (
        _id TEXT PRIMARY KEY, userId TEXT, code TEXT UNIQUE, name TEXT,
        file TEXT, createdAt TEXT
      )''');
    batch.execute('''
      CREATE TABLE stok (
        _id TEXT PRIMARY KEY, userId TEXT, cabangId TEXT,
        produkId TEXT REFERENCES produk(_id) ON DELETE CASCADE,
        produkKategoriId TEXT, produkMerkId TEXT, name TEXT, code TEXT,
        qty INTEGER, satuan TEXT, harga INTEGER, hargaModal INTEGER,
        createdAt TEXT, updatedAt TEXT
      )''');
    batch.execute('''
      CREATE TABLE kategori (
        _id TEXT PRIMARY KEY, userId TEXT, code TEXT, name TEXT, image TEXT
      )''');
    batch.execute('''
      CREATE TABLE merk (
        _id TEXT PRIMARY KEY, userId TEXT, code TEXT, name TEXT
      )''');
    batch.execute('''
      CREATE TABLE transaksi (
        _id TEXT PRIMARY KEY, userId TEXT, name TEXT, noInvoice TEXT UNIQUE,
        cabangId TEXT, date TEXT, discountName TEXT, discountUnit TEXT,
        discountAmount INTEGER, subJumlahTransaksi INTEGER,
        jumlahPembayaran INTEGER, jumlahTransaksi INTEGER, kembalian INTEGER,
        metode TEXT DEFAULT 'cash', createdAt TEXT
      )''');
    batch.execute('''
      CREATE TABLE pesanan (
        _id TEXT PRIMARY KEY, userId TEXT, noInvoice TEXT, cabangId TEXT,
        stokId TEXT, produkId TEXT, code TEXT, name TEXT,
        harga INTEGER, qty INTEGER, total INTEGER
      )''');
    batch.execute('CREATE INDEX pesanan_invoice ON pesanan(noInvoice)');
    batch.execute('''
      CREATE TABLE memberships (
        _id TEXT PRIMARY KEY, userId TEXT, cabangId TEXT, memberId TEXT UNIQUE,
        email TEXT, nik TEXT, name TEXT, phone TEXT, address TEXT,
        poin INTEGER DEFAULT 0, createdAt TEXT
      )''');
    batch.execute('''
      CREATE TABLE kasbon (
        _id TEXT PRIMARY KEY, userId TEXT, cabangId TEXT,
        membershipsId TEXT, memberId TEXT, transaksiId TEXT, note TEXT, date TEXT, status TEXT DEFAULT 'Belum dibayar',
        createdAt TEXT
      )''');
    batch.execute('''
      CREATE TABLE rekap_kas (
        _id TEXT PRIMARY KEY, karyawanId TEXT, cabangId TEXT,
        kasAwal INTEGER, kasAkhir INTEGER DEFAULT 0, selisih INTEGER DEFAULT 0,
        date TEXT, createdAt TEXT, updatedAt TEXT
      )''');
    await batch.commit(noResult: true);
  }
}
