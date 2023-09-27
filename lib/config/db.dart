import 'dart:io';
import 'package:fajarjayaspring_app/models/kas_model.dart';
import 'package:fajarjayaspring_app/models/produk_model.dart';
import 'package:fajarjayaspring_app/models/saldo_model.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/keranjang_model.dart';
import '../models/pembelian_model.dart';
import '../models/pengeluaran_model.dart';
import '../models/penjualan_model.dart';
import '../models/users_model.dart';

class DatabaseService {
  final String _databaseName = 'bsPembukuan.db';

  final int _databaseversion = 2;

  final String table1 = 'users';
  final String table2 = 'kas';
  final String table3 = 'pembelian';
  final String table4 = 'pengeluaran';
  final String table5 = 'produk';
  final String table6 = 'penjualan';
  final String table7 = 'saldo';
  final String table8 = 'keranjang';
  final String table9 = 'saldopenjualan';

  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, _databaseName);

    return openDatabase(path, version: _databaseversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $table1 (id INTEGER PRIMARY KEY, nama TEXT NULL, notelp TEXT NULL, email TEXT NULL, alamat TEXT NULL, prov TEXT NULL, kota TEXT NULL ,status INTEGER NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table2 (id INTEGER PRIMARY KEY, deskripsi TEXT NULL, biaya INTEGER NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table3 (id INTEGER PRIMARY KEY, nama_barang TEXT NULL, jmlh_brng INTEGER NULL, satuan TEXT NULL, harga INTEGER NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table4 (id INTEGER PRIMARY KEY, nama_pengeluaran TEXT NULL, biaya INTEGER NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table5 (id INTEGER PRIMARY KEY, nama TEXT NULL, deskripsi TEXT NULL, sku TEXT NULL, harga_pokok INTEGER NULL, harga_jual INTEGER NULL, stock INTEGER NULL, satuan TEXT NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table6 (id INTEGER PRIMARY KEY, nama STRING NULL, nama_pembeli STRING NULL, produk TEXT NULL, jumlah_produk INTEGER NULL, total_produk INTEGER NULL, subtotal INTEGER NULL, ongkos_kirim INTEGER NULL, biaya_lain INTEGER NULL, potongan_harga INTEGER NULL, total INT NULL,pembayaran TEXT NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table7 (id INTEGER PRIMARY KEY, saldo INTEGER NULL, createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table8 (id INTEGER PRIMARY KEY, nama TEXT NULL, deskripsi TEXT NULL, jumlah INTEGER NULL, total INTEGER NULL, stock INTEGER NULL,id_bahan INTEGER NULL,  createdAt TEXT, updatedAt TEXT)''');
    await db.execute(
        '''CREATE TABLE $table9 (id INTEGER PRIMARY KEY, total INTEGER NULL,ongkir INTEGER null,  createdAt TEXT, updatedAt TEXT)''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    final query = await _database!.insert(table1, row);
    return query;
  }


  Future<void> saveUserData({
    required bool status,
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required String prov,
    required String kota,
  }) async {
    await _database!.insert('users', {
      'status': status ? 1 : 0,
      'nama': name,
      'notelp': phoneNumber,
      'email': email,
      'alamat': address,
      'prov': prov,
      'kota': kota,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    });
  }

  Future<List<UserModel>> alls() async {
    final data = await _database!.query('users');
    List<UserModel> result = data.map((e) => UserModel.fromJson(e)).toList();

    return result;
  }

  Future<Map<String, dynamic>> getUserData() async {
    final data = await _database!.query('users');

    if (data.isNotEmpty) {
      return data[0];
    } else {
      return {};
    }
  }

  Future<List<PembelianModel>> allData() async {
    final data = await _database!.query('pembelian');
    List<PembelianModel> result =
        data.map((e) => PembelianModel.fromJson(e)).toList();
    return result;
  }

  Future<List<PengeluaranModel>> allPeng() async {
    final data = await _database!.query('pengeluaran');
    List<PengeluaranModel> result =
        data.map((e) => PengeluaranModel.fromJson(e)).toList();

    return result;
  }

  Future<List<PenjualanModel>> allPen() async {
    final data = await _database!.rawQuery('SELECT * FROM penjualan GROUP BY nama');
    List<PenjualanModel> result =
        data.map((e) => PenjualanModel.fromJson(e)).toList();
    return result;
  }

  Future<List<KasModel>> allDataKas() async {
    final data = await _database!.query('kas');
    List<KasModel> result = data.map((e) => KasModel.fromJson(e)).toList();
    return result;
  }
  Future<List<PenjualanModel>> allPenjuals() async {
    final data = await _database!.query('penjualan');
    List<PenjualanModel> result = data.map((e) => PenjualanModel.fromJson(e)).toList();
    return result;
  }

  Future<List<KeranjangModel>> allDataKar() async {
    final data = await _database!.query('keranjang');
    List<KeranjangModel> result = data.map((e) => KeranjangModel.fromJson(e)).toList();
    return result;
  }

  Future<List<ProdukModel>> allProduks() async {
    final data = await _database!.query('produk');
    List<ProdukModel> result = data.map((e) => ProdukModel.fromJson(e)).toList();
    return result;
  }

    Future<List<SaldoModel>> allSaldo() async {
    final data = await _database!.rawQuery('SELECT * FROM saldo');
    List<SaldoModel> result = data.map((e) => SaldoModel.fromJson(e)).toList();
    return result;
  }
}
