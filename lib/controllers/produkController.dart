import 'package:fajarjayaspring_app/config/db.dart';
import 'package:sqflite/sqflite.dart';

class ProdukController {
  final DatabaseService databaseService = DatabaseService();

  Future<void> insert({
    required String nama,
    required String deskripsi,
    required String sku,
    required int stock,
    required String satuan,
    required int harga_jual,
    required int harga_pokok,
  }) async {
    final Database _database = await databaseService.database();
    await _database.insert('produk', {
      'nama': nama,
      'deskripsi': deskripsi,
      'sku': sku,
      'stock': stock,
      'satuan': satuan,
      'harga_pokok': harga_pokok,
      'harga_jual': harga_jual,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    });

  }

  Future<void> updateDatas(
      {required String nama,
      required String deskripsi,
      required String sku,
      required int stock,
      required String satuan,
      required int harga_jual,
      required int harga_pokok,
      required int idPar}) async {
    final Database _database = await databaseService.database();
    await _database.update(
        'produk',
        {
          'nama': nama,
          'deskripsi': deskripsi,
          'sku': sku,
          'stock': stock,
          'satuan': satuan,
          'harga_pokok': harga_pokok,
          'harga_jual': harga_jual,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [idPar]);
  }

  Future<void> delete({required int idParams}) async {
    final Database _database = await databaseService.database();
    await _database.delete('produk', where: 'id = ?', whereArgs: [idParams]);
  }

  Future<List> totalHpp() async {
    final Database _database = await databaseService.database();
    List datas = await  _database.rawQuery('SELECT SUM(harga_pokok) as hpp FROM produk');
    return datas;

  }




}
