import 'package:sqflite/sqflite.dart';

import '../config/db.dart';

class SaldoController {
  final DatabaseService databaseService = DatabaseService();

  Future<void> savesaldoData() async {
    final Database _database = await databaseService.database();
    await _database.insert('saldo', {
      'saldo': 0,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    });

    await _database.insert('saldopenjualan', {
      'total': 0,
      'ongkir': 0,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    });
  }

  Future<List> all() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM saldo');
    return data;
  }

  Future<int> allKas() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT SUM(biaya) AS total FROM kas');

     final total = data.first['total'] as int;
    return total;
  }
}
