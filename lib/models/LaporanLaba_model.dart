import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/suplaier_model.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';

class LaporanLaba {
  final UserModel userModel;
  final Alls all;
  final List<PenjualanModel> items;
  // final PembelianModel pembelianModel;


  const LaporanLaba({
    required this.userModel,
    required this.all,
    required this.items,
  });
}


class Alls {
  final int keuntungankotor;
  final int keuntunganbersih;
  final int penjualan;


  const Alls({
    required this.keuntungankotor,
    required this.keuntunganbersih,
    required this.penjualan,

  });
}
