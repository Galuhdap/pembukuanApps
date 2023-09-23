import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/suplaier_model.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';

class LaporanPengeluaran {

  final UserModel userModel;
   final List<PembelianModel> items;
  final List<PengeluaranModel> itemsPengeluaran;
  final Alls all;


  const LaporanPengeluaran({

    required this.userModel,
    required this.items,
    required this.itemsPengeluaran,
    required this.all,
  });
}
 

class Alls {
  final int pemblihanbahan;
  final int pengeluaran;
  final int total;
  

  const Alls({
    required this.pemblihanbahan,
    required this.pengeluaran,
    required this.total,
  });
}
