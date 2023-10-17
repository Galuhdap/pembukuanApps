import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/suplaier_model.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';

class LaporanSemua {

  final UserModel userModel;
  final List<PembelianModel> items;
  final List<PenjualanModel> itemsPenjualan;
  final List<PenjualanModel> itemsHutangPenjualan;
  final List<PengeluaranModel> itemsPengeluaran;
  final Alls all;


  const LaporanSemua({

    required this.userModel,
    required this.items,
    required this.itemsPenjualan,
    required this.itemsHutangPenjualan,
    required this.itemsPengeluaran,
    required this.all,
  });
}
 

class Alls {
  final int kas;
  final int pemblihanbahan;
  final int pengeluaran;
  final int penjualan;
  final int total;
  

  const Alls({
    required this.kas,
    required this.pemblihanbahan,
    required this.pengeluaran,
    required this.penjualan,
    required this.total,
  });
}
