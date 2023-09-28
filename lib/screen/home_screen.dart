import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/controllers/saldoController.dart';
import 'package:fajarjayaspring_app/controllers/usersController.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';
import 'package:fajarjayaspring_app/screen/daftarproduk_screen.dart';
import 'package:fajarjayaspring_app/screen/kas_screen.dart';
import 'package:fajarjayaspring_app/screen/pembelianBahan_screen.dart';
import 'package:fajarjayaspring_app/screen/pengeluaran_screen.dart';
import 'package:fajarjayaspring_app/screen/penjualan_screen.dart';
import 'package:fajarjayaspring_app/screen/profile_screen.dart';
import 'package:flutter/material.dart';

import '../data/format.dart';
import '../models/saldo_model.dart';
import '../widget/point_card.dart';
import 'TabbarPage/tebBar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseService databaseService = DatabaseService();
  UsersController usersController = UsersController();
  SaldoController saldoController = SaldoController();

  List data = [];
  List saldos = [];

  Future fetchData() async {
    data = await usersController.all();
    List saldoss = await saldoController.all();
    setState(() {
      saldos = saldoss;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List>(
              future: saldoController.all(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final List<SaldoModel> saldos = snapshot.data!.map((item) {
                    return SaldoModel(
                      id: item['id'],
                      saldo: item['saldo'] != null ? item['saldo'].toInt() : 0,
                    );
                  }).toList();

                  return FutureBuilder<List>(
                    future: usersController.all(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        final List<UserModel> users =
                            snapshot.data!.map((item) {
                          return UserModel(id: item['id'], nama: item['nama']);
                        }).toList();
                        return PoinCard(
                            size,
                            users.length > 0 ? users[0].nama : "",
                            CurrencyFormat.convertToIdr(
                                saldos.length > 0 ? saldos[0].saldo! : 0, 0),
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builde) {
                                return KasScreen();
                              },
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        });
                      }
                    },
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 35, right: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builde) {
                            return PembelianbahanScreen();
                          },
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child:
                        menu(size, "assets/logo/add.png", 'Pembelian\nBahan'),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builde) {
                              return PengeluaranScreen();
                            },
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: menu(
                          size, "assets/logo/cttn.png", 'Catat\nPengeluaran')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 35, right: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builde) {
                              return DaftarProdukScreen();
                            },
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child:
                          menu(size, "assets/logo/prdk.png", 'Daftar\nProduk')),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builde) {
                              return PenjualanScreen();
                            },
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: menu(
                          size, "assets/logo/pnjl.png", 'Catat\nPenjualan')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 35, right: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builde) {
                              return TebBarScreen();
                            },
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: menu(size, "assets/logo/laporan.png", 'Laporan')),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builde) {
                              return ProfileScreen();
                            },
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: menu(
                          size, "assets/logo/profile.png", 'Profile\nUsaha')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 35),
              child: Column(
                children: [
                  Text(
                    'DIDANAI OLEH:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3F51B5),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 7)),
                  Text(
                    'Direktorat Riset, Teknologi, dan Pengabdian Kepada Masyarakat, Direktorat\nJenderal Pendidikan Tinggi, Riset dan Teknologi, Kementrian Pendidikan,\nKebudayaan, Riset, dan Teknologi Republik Indonesia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3F51B5),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.22,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 7)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container menu(Size size, icn, ttl) {
    return Container(
      width: size.width * 0.38,
      height: 160,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 16,
            offset: Offset(0, 0),
            spreadRadius: -6,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icn,
            width: 56,
            height: 56,
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Text(
            ttl,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}
