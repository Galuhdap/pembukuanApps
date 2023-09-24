import 'package:fajarjayaspring_app/config/db.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiController {
  final DatabaseService databaseService = DatabaseService();

  Future<void> insert(
      {required String nama,
      required String deskripsi,
      required int stock,
      required int jumlah,
      required int totals,
      required int id_bahan,
      required int idParams}) async {
    final Database _database = await databaseService.database();
    await _database.insert('keranjang', {
      'nama': nama,
      'deskripsi': deskripsi,
      'stock': stock,
      'jumlah': jumlah,
      'total': totals,
      'id_bahan': id_bahan,
      'createdAt': DateTime.now().toString(),
      'updatedAt': DateTime.now().toString(),
    });

    await _database.update(
        'produk',
        {
          'stock': stock - jumlah,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [idParams]);
  }

  Future<void> insertpenjualan(
      {required String nama,
      required String nama_pembeli,
      required String pembayaran,
      required int subtotal,
      required int biaya_lain,
      required int ongkos_kirim,
      required int potongan_harga,
      required int total,
      required int idP}) async {
    final Database _database = await databaseService.database();

    final List<Map<String, dynamic>> keranjang =
        await _database.rawQuery('SELECT * FROM keranjang');

    for (var result in keranjang) {
      await _database.insert('penjualan', {
        'nama': nama,
        'nama_pembeli': nama_pembeli,
        'produk': result['nama'],
        'pembayaran': pembayaran,
        'jumlah_produk': result['jumlah'],
        'total_produk': result['total'],
        'subtotal': subtotal,
        'biaya_lain': biaya_lain,
        'ongkos_kirim': ongkos_kirim,
        'potongan_harga': potongan_harga,
        'total': total,
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      });
    }

    final List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT * FROM saldopenjualan');

    final List<Map<String, dynamic>> results =
        await _database.rawQuery('SELECT * FROM saldo');

    await _database.update(
        'saldopenjualan',
        {
          'total': result[0]['total'] + total,
          'ongkir': result[0]['ongkir'] + ongkos_kirim,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [idP]);

    await _database.update(
        'saldo',
        {
          'saldo': results[0]['saldo'] + total,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [idP]);
  }

  Future<int> subtotal() async {
    final Database _database = await databaseService.database();
    final result =
        await _database.rawQuery('SELECT SUM(total) as total FROM keranjang');
    final total = result.first['total'] as int? ?? 0;
    return total;
  }

  Future<void> delete({required int idParams}) async {
    final Database _database = await databaseService.database();

    final data = await _database
        .rawQuery('SELECT * FROM keranjang WHERE id = ${idParams}');

    if (data.isNotEmpty) {
      final idBahan = data[0]['id_bahan'] ?? 0;
      final bahan = await _database
          .rawQuery('SELECT * FROM produk WHERE id = ${idBahan}');
      int bahans = (bahan[0]['stock'] ?? 0) as int;
      int keran = (data[0]['jumlah'] ?? 0) as int;

      int totals = bahans + keran;

      await _database.update(
          'produk',
          {
            'stock': totals,
          },
          where: 'id = ?',
          whereArgs: [idBahan]);
    }

    await _database.delete('keranjang', where: 'id = ?', whereArgs: [idParams]);
  }

  Future<void> deletePen({required String idParams, required int total}) async {
    final Database _database = await databaseService.database();
    await _database
        .delete('penjualan', where: 'nama = ?', whereArgs: [idParams]);

    final List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT * FROM saldopenjualan');

    await _database.update(
        'saldopenjualan',
        {
          'total': result[0]['total'] - total,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
        },
        where: 'id = ?',
        whereArgs: [1]);
  }

  Future<List> alls() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM saldopenjualan');
    return data;
  }

  Future<void> deleteKer() async {
    final Database _database = await databaseService.database();
    await _database.delete('keranjang');
  }

  Future<List> all() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery('SELECT * FROM penjualan');
    return data;
  }

  Future<List> totalProd() async {
    final Database _database = await databaseService.database();
    List datas = await _database
        .rawQuery('SELECT SUM(jumlah_produk) as jumlah FROM penjualan');
    return datas;
  }

  Future<List> allProd() async {
    final Database _database = await databaseService.database();
    List datas = await _database.rawQuery(
        'SELECT produk,SUM(jumlah_produk) AS jmlh, SUM(total_produk) AS total FROM penjualan GROUP BY produk');
    return datas;
  }

  Future<int> ongkir() async {
    final Database _database = await databaseService.database();
    List data = await _database
        .rawQuery('SELECT SUM(ongkos_kirim) as total FROM penjualan');

    final total = data.first['total'] as int;

    return total;
  }

  Future<int> filterDataByDateOngkir(String? targetDate) async {
    final Database _database = await databaseService.database();

    final data = await _database.rawQuery(
      'SELECT SUM(ongkos_kirim) as total FROM penjualan WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final total = data.first['total'] as int;

    return total;
  }

  Future<int> totals() async {
    final Database _database = await databaseService.database();
    final data = await _database.rawQuery(
      'SELECT SUM(total) as total FROM penjualan',
    );

    final total = data.first['total'] as int;
    return total;
  }

  Future<int> filterDataByDate(String? targetDate) async {
    final Database _database = await databaseService.database();

    final data = await _database.rawQuery(
      'SELECT SUM(total) as total FROM penjualan WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final total = data.first['total'] as int;

    return total;
  }

  Future<int> totalKotor() async {
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

  Future<int> filterDataByDateKotor(String? targetDate) async {
    final Database _database = await databaseService.database();

    final data = await _database.rawQuery(
      'SELECT SUM(total) as total FROM penjualan WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );
    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );
    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final total = data.first['total'] as int? ?? 0;
    final harga = bahan.first['harga'] as int? ?? 0;
    final biya = pengeluaran.first['biaya'] as int? ?? 0;

    final totals = total + harga + biya;

    return totals;
  }


  Future<int> totalBersih() async {
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

  Future<int> filterDataByDateBersih(String? targetDate) async {
    final Database _database = await databaseService.database();

    final data = await _database.rawQuery(
      'SELECT SUM(total) as total FROM penjualan WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );
    final bahan = await _database.rawQuery(
      'SELECT SUM(harga) as harga FROM pembelian WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );
    final pengeluaran = await _database.rawQuery(
      'SELECT SUM(biaya) as biaya FROM pengeluaran WHERE createdAt LIKE ?',
      ['$targetDate%'],
    );

    final total = data.first['total'] as int? ?? 0;
    final harga = bahan.first['harga'] as int? ?? 0;
    final biya = pengeluaran.first['biaya'] as int? ?? 0;

    final totals = total - harga - biya;

    return totals;
  }

   Future<int> totalSemua() async {
    final Database _database = await databaseService.database();
    // final data = await _database.rawQuery(
    //   'SELECT SUM(total) as total FROM penjualan',
    // );

    // final bahan = await _database.rawQuery(
    //   'SELECT SUM(harga) as harga FROM pembelian',
    // );

    // final pengeluaran = await _database.rawQuery(
    //   'SELECT SUM(biaya) as biaya FROM pengeluaran',
    // );
    final kas = await _database.rawQuery(
      'SELECT SUM(saldo) as total FROM saldo',
    );
    // final hpp = await _database.rawQuery(
    //   'SELECT SUM(harga_pokok) as hpp FROM produk',
    // );
 


    // final total = data.first['total'] as int? ?? 0;
    // final harga = bahan.first['harga'] as int? ?? 0;
    // final biya = pengeluaran.first['biaya'] as int? ?? 0;
    final kass = kas.first['total'] as int? ?? 0;
    // final hpps = hpp.first['hpp'] as int? ?? 0;

    // final totals = total + harga + biya + kass + hpps;

    return kass;
  }
}
