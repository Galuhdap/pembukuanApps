import 'package:fajarjayaspring_app/controllers/produkController.dart';
import 'package:fajarjayaspring_app/models/produk_model.dart';
import 'package:fajarjayaspring_app/screen/daftarprodukAdd_screen.dart';
import 'package:fajarjayaspring_app/screen/daftraprodukEdit_screen.dart';
import 'package:fajarjayaspring_app/screen/home_screen.dart';
import 'package:fajarjayaspring_app/widget/appBarCos.dart';
import 'package:flutter/material.dart';

import '../config/db.dart';
import '../data/format.dart';
import '../widget/transaction_card.dart';

class DaftarProdukScreen extends StatefulWidget {
  const DaftarProdukScreen({super.key});

  @override
  State<DaftarProdukScreen> createState() => _DaftarProdukScreenState();
}

class _DaftarProdukScreenState extends State<DaftarProdukScreen> {
  DatabaseService? databaseService;

  ProdukController produkController = ProdukController();

  String query = "";

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  Future delete(int id) async {
    await produkController.delete(idParams: id);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseService = DatabaseService();
    initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                appbarCos(size, "Daftar Produk", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (builde) {
                        return HomeScreen();
                      },
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    width: size.width * 0.9,
                    height: 40,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      enabled: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
                FutureBuilder<List<ProdukModel>>(
                  future: databaseService!.allProduks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 250, bottom: 250),
                          child: Center(
                            child: Text("DATA KOSONG"),
                          ),
                        );
                      }
                      final List<ProdukModel> filteredData = snapshot.data!
                          .where((item) => item.nama!
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                      return Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Container(
                          width: size.width * 0.9,
                          height: size.height * 0.7,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredData.length,
                            itemBuilder: (BuildContext context, index) {
                              return productCard(
                                size,
                                filteredData[index].nama,
                                CurrencyFormat.convertToIdr(
                                    filteredData[index].harga_jual, 0),
                                filteredData[index].sku,
                                filteredData[index].stock.toString(),
                                filteredData[index].satuan,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builde) {
                                        return DaftarprodukEditScreen(
                                          produkModel: snapshot.data![index],
                                        );
                                      },
                                    ),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                () {
                                  delete(snapshot.data![index].id!);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 15),
                  child: Column(
                    children: [
                      Text(
                        'DIDANAI OLEH:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 8,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 7)),
                      Text(
                        'Direktorat Riset, Teknologi, dan Pengabdian Kepada Masyarakat, Direktorat\nJenderal Pendidikan Tinggi, Riset dan Teknologi, Kementrian Pendidikan,\nKebudayaan, Riset, dan Teknologi Republik Indonesia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
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
            Positioned(
              top: size.height * 0.85,
              left: size.width * 0.77,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builde) {
                        return DaftarprodukAddScreen();
                      },
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: 58,
                  height: 58,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: ShapeDecoration(
                            color: Color(0xFF3F51B5),
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 16,
                                offset: Offset(0, 0),
                                spreadRadius: -6,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
