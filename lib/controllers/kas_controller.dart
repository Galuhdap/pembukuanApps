import 'package:fajarjayaspring_app/config/db.dart';
import 'package:sqflite/sqflite.dart';

class KasController {
  DatabaseService databaseService = DatabaseService();

  Future<void> insert(
      {required String deskripsi,
      required int biaya,
      required int idParams,
      required String tgl,
      }) async {
    final Database _database = await databaseService.database();
    await _database.insert('kas', {
      'deskripsi': deskripsi,
      'biaya': biaya,
      'createdAt': tgl,
      'updatedAt': DateTime.now().toString(),
    });

    final List<Map<String, dynamic>> results =
        await _database.rawQuery('SELECT * FROM saldo');

    await _database.update(
        'saldo',
        {
          'saldo': results[0]['saldo'] + biaya,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [idParams]);
  }


  Future delete({required int idParams, required int idP, required int biaya}) async {
    final Database _database = await databaseService.database();
    await _database.delete('kas', where: 'id = ?', whereArgs: [idParams]);

        final List<Map<String, dynamic>> results =
        await _database.rawQuery('SELECT * FROM saldo');

    if(results.isNotEmpty){

      final datas = results[0]['saldo'] ?? 0;
         await _database.update(
        'saldo',
        {
          'saldo': datas - biaya,
        },
        where: 'id = ?',
        whereArgs: [idP]);
    }
  }
}
