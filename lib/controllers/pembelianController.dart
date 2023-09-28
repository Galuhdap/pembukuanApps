

import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:sqflite/sqflite.dart';

class PembelianController {
  final DatabaseService databaseService = DatabaseService();

  Future<void> insert({
    required String nama_barang,
    required int jmlh_brng,
    required String satuan,
    required int harga,
    required String tgl,
  }) async {
    final Database _database = await databaseService.database();
    await _database.insert('pembelian', {
      'nama_barang': nama_barang,
      'jmlh_brng': jmlh_brng,
      'satuan': satuan,
      'harga': harga,
      'createdAt': tgl,
      'updatedAt': DateTime.now().toString(),
    });

    final List<Map<String, dynamic>> total =
        await _database.rawQuery('SELECT * FROM saldo');

    await _database.update(
        'saldo',
        {
          'saldo': total[0]['saldo'] - harga,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [1]);
  }

  Future<void> delete({required int idParams, required int harga}) async {
    final Database _database = await databaseService.database();
    await _database.delete('pembelian', where: 'id = ?', whereArgs: [idParams]);

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
        await _database.rawQuery('SELECT SUM(harga) as harga FROM pembelian');
    return data;
  }

}
