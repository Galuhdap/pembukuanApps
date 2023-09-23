import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';
import 'package:sqflite/sqflite.dart';

class PengeluaranController {
  final DatabaseService databaseService = DatabaseService();

  Future<void> insert({
    required String nama_pengeluaran,
    required int biaya,
  }) async {
    final Database _database = await databaseService.database();
    await _database.insert('pengeluaran', {
      'nama_pengeluaran': nama_pengeluaran,
      'biaya': biaya,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    });

    final List<Map<String, dynamic>> total =
        await _database.rawQuery('SELECT * FROM saldo');

    await _database.update(
        'saldo',
        {
          'saldo': total[0]['saldo'] - biaya,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [1]);
  }


  Future<void> delete({required int idParams, required int harga}) async {
    final Database _database = await databaseService.database();
    await _database
        .delete('pengeluaran', where: 'id = ?', whereArgs: [idParams]);

    final List<Map<String, dynamic>> total =
        await _database.rawQuery('SELECT * FROM saldo');

    await _database.update(
        'saldo',
        {
          'saldo': total[0]['saldo'] + harga,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [1]);
  }

  Future<List> all() async {
    final Database _database = await databaseService.database();
    final data =
        await _database.rawQuery('SELECT SUM(biaya) as biaya FROM pengeluaran');
    return data;
  }

  Future<int> totalPeng() async {
    final Database _database = await databaseService.database();

    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran',
    );

    final biaya = pengeluaran.first['biaya'] as int? ?? 0;

    return biaya;
  }

  Future<int> filterDataByDatePeng(String? targetDate) async {
    final Database _database = await databaseService.database();

    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final biaya = pengeluaran.first['biaya'] as int? ?? 0;

    return biaya;
  }

  Future<int> totalBahan() async {
    final Database _database = await databaseService.database();

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian',
    );

    final harga = bahan.first['harga'] as int? ?? 0;

    return harga;
  }

  Future<int> filterDataByDateBahan(String? targetDate) async {
    final Database _database = await databaseService.database();

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final harga = bahan.first['harga'] as int? ?? 0;

    return harga;
  }

  Future<int> totalKeseluruhan() async {
    final Database _database = await databaseService.database();

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian',
    );
    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran',
    );

    final harga = bahan.first['harga'] as int? ?? 0;
    final biaya = pengeluaran.first['biaya'] as int? ?? 0;

    final totals = harga + biaya;

    return totals;
  }
  Future totalKeseluruhan2() async {
    final Database _database = await databaseService.database();

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian',
    );
    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran',
    );

    final harga = bahan.first['harga'] as int? ?? 0;
    final biaya = pengeluaran.first['biaya'] as int? ?? 0;

    final totals = harga + biaya;

    return totals;
  }

  Future<int> filterDataByDateKeseluruhan(String? targetDate) async {
    final Database _database = await databaseService.database();

    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );
    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final harga = bahan.first['harga'] as int? ?? 0;
    final biaya = pengeluaran.first['biaya'] as int? ?? 0;

    final totals = harga + biaya;

    return totals;
  }
}
