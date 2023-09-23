import 'package:fajarjayaspring_app/config/db.dart';
import 'package:sqflite/sqflite.dart';


class UsersController {
  final DatabaseService databaseService = DatabaseService();

    Future<void> saveUserUpdate({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required String prov,
    required String kota,
    required int idParams
  }) async {
    final Database _database = await databaseService.database();
    await _database.update('users', {
      'nama': name,
      'notelp': phoneNumber,
      'email': email,
      'alamat': address,
      'prov': prov,
      'kota': kota,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    }, where: 'id = ?', whereArgs: [idParams]);
  }


  Future<List> all() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM users');
    return data;
  }
}
