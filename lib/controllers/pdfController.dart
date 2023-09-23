import 'package:fajarjayaspring_app/config/db.dart';
import 'package:sqflite/sqflite.dart';

class PdfController {
  final DatabaseService databaseService = DatabaseService();

  Future<List> alls() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM keranjang');
    return data;
  }
  Future<List> allPenjualan() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM penjualan');
    return data;
  }

  Future<List> allPem() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM pembelian');
    return data;
  }

  Future<List> allPeng() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM pengeluaran');
    return data;
  }

  Future<List> all(String nama) async {
    final Database _database = await databaseService.database();
    final data = await _database
        .query("penjualan", where: "nama_pembeli = ?", whereArgs: [nama]);
    return data;
  }

  Future<List> allss(String nama) async {
    final Database _database = await databaseService.database();
    final data =
        await _database.query("users", where: "nama = ?", whereArgs: [nama]);
    return data;
  }

  Future<List> user() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM users');
    return data;
  }

  Future jumlahPen() async {}

  Future totalKotor() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery(
      'SELECT SUM(total) as total FROM penjualan',
    );

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian',
    );

    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran',
    );

    final total = data.first['total'] as int? ?? 0;
    final harga = bahan.first['harga'] as int? ?? 0;
    final biya = pengeluaran.first['biaya'] as int? ?? 0;
    final totals = total + harga + biya;

    return totals;
  }

  Future totalBersih() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery(
      'SELECT SUM(total) as total FROM penjualan',
    );

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian',
    );

    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran',
    );

    final total = data.first['total'] as int? ?? 0;
    final harga = bahan.first['harga'] as int? ?? 0;
    final biya = pengeluaran.first['biaya'] as int? ?? 0;
    final totals = total - harga - biya;

    return totals;
  }
}
