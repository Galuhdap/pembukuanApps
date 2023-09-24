import 'package:fajarjayaspring_app/controllers/transactionController.dart';
import 'package:fajarjayaspring_app/widget/appBarCos.dart';
import 'package:flutter/material.dart';

import '../config/db.dart';
import '../controllers/produkController.dart';
import '../data/format.dart';
import '../models/produk_model.dart';
import '../widget/transaction_card.dart';

class CatatanpenjualanAddScreen extends StatefulWidget {
  const CatatanpenjualanAddScreen({super.key});

  @override
  State<CatatanpenjualanAddScreen> createState() =>
      _CatatanpenjualanAddScreenState();
}

class _CatatanpenjualanAddScreenState extends State<CatatanpenjualanAddScreen> {
  DatabaseService? databaseService;

  ProdukController produkController = ProdukController();
  TransaksiController transaksiController = TransaksiController();
  TextEditingController jmlhController = TextEditingController();

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  String jmlhError = '';
   String errorText = '';

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
                  Navigator.pop(context);
                }),
                FutureBuilder<List<ProdukModel>>(
                  future: databaseService!.allProduks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 340, bottom: 298),
                          child: Center(
                            child: Text("DATA KOSONG"),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Container(
                          width: size.width * 0.9,
                          height: size.height * 0.79,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 10),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, index) {
                              return productCard2(
                                snapshot.data![index].nama,
                                CurrencyFormat.convertToIdr(
                                    snapshot.data![index].harga_jual, 0),
                                snapshot.data![index].sku,
                                snapshot.data![index].stock.toString(),
                                snapshot.data![index].satuan,
                                () {
                                  if (snapshot.data![index].stock! > 0) {
                                    add(
                                      size,
                                      snapshot.data![index].nama,
                                      snapshot.data![index].deskripsi,
                                      snapshot.data![index].stock.toString(),
                                      snapshot.data![index].harga_jual,
                                      snapshot.data![index].id,
                                      snapshot.data![index].id,
                                      snapshot.data![index].stock
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Center(
                                          child: Text(
                                            'Stock Habis !!',
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                size,
                                
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
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  child: Column(
                    children: [
                      Text(
                        'DIDANAI OLEH:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
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
          ],
        ),
      ),
    );
  }

  Future add(Size size, nama, des, stock, hrg, id, id_bahan, stockAda) {
    TextEditingController namaController = TextEditingController(text: nama);
    TextEditingController desController = TextEditingController(text: des);
    TextEditingController stockController = TextEditingController(text: stock);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Tambah Ke Keranjang',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: Container(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width * 0.67,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFA8A8A8),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Nama Produk",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.67,
                    height: 40,
                    child: TextField(
                      controller: namaController,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Deskripsi Produk",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.67,
                    height: 40,
                    child: TextField(
                      controller: desController,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Text(
                          "Stock",
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.67,
                        height: 40,
                        child: TextField(
                          controller: stockController,
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Color(0xFFA8A8A8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Color(0xFFA8A8A8),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Masukan Jumlah",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.67,
                    height: 40,
                    child: TextField(
                      controller: jmlhController,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.3,
                      height: 37,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.50, color: Color(0xFF3F51B5)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(
                          "BATAL",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.3,
                      height: 37,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF3F51B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                        final int enteredStock = int.tryParse(jmlhController.text) ?? 0;
                          setState(() {
                            jmlhError = jmlhController.text.isEmpty
                                ? 'nama harus diisi'
                                : '';
                            errorText = enteredStock > stockAda
                                ? 'Stock Tidak Cukup'
                                : '';
                          });

                          if (jmlhError.isEmpty && enteredStock <= stockAda && enteredStock > 0) {
                            await transaksiController.insert(
                                nama: namaController.text,
                                deskripsi: desController.text,
                                stock: int.parse(stockController.text),
                                jumlah: int.parse(jmlhController.text),
                                totals:
                                    int.parse(jmlhController.text) * hrg as int,
                                id_bahan: id_bahan,
                                idParams: id);
                            Navigator.pop(context);
                            setState(() {});
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    'Masukan Input Dengan Benar !!',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
