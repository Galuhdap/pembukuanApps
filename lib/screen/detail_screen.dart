import 'package:fajarjayaspring_app/controllers/transactionController.dart';
import 'package:fajarjayaspring_app/screen/pdf/pdfPriviewPage.dart';
import 'package:fajarjayaspring_app/screen/penjualan_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/db.dart';
import '../data/format.dart';
import '../models/keranjang_model.dart';

class DetailScreen extends StatefulWidget {
  final String namatransaksi;
  final String namapembeli;
  final String tanggal;
  final String pembayaran;
  final String kode_invoice;
  final String hutang;

  final int subtotal;
  final int pembayaranAwal;
  final int ongkir;
  final int lain;
  final int potongan;
  final int total;
  DetailScreen({
    super.key,
    required this.namatransaksi,
    required this.namapembeli,
    required this.tanggal,
    required this.pembayaran,
    required this.subtotal,
    required this.ongkir,
    required this.potongan,
    required this.lain,
    required this.pembayaranAwal,
    required this.total,
    required this.kode_invoice,
    required this.hutang,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DatabaseService? databaseService;

  TransaksiController transaksiController = TransaksiController();

  Future initDatabase() async {
    await databaseService!.database();
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
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: size.width,
                  height: 254,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment(0.90, -0.43),
                      begin: Alignment(-0.9, 0.43),
                      colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 40, left: 30, right: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Detail Penjualan",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/logo/tuturi.png",
                                    width: 45,
                                    height: 45,
                                  ),
                                  Image.asset(
                                    "assets/logo/untag.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  Image.asset(
                                    "assets/logo/logounesa.png",
                                    width: 45,
                                    height: 45,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 33, top: 140),
                    child: Container(
                      width: size.width * 0.85,
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
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 30, right: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(size, 'Kode Invoice', widget.kode_invoice),
                            text(
                              size,
                              'Tanggal',
                              DateFormat(' dd MMMM yyyy', 'id_ID')
                                  .format(DateTime.parse(widget.tanggal)),
                            ),
                            text(size, 'Nama Pembeli', widget.namapembeli),
                            text(size, 'Nama Transaksi', widget.namatransaksi),
                            text(size, 'Pembayaran', widget.pembayaran),
                            text(size, 'Pembayaran Awal',  CurrencyFormat.convertToIdr(widget.pembayaranAwal, 0)),
                            text(
                              size,
                              'Jatuh Tempo',
                              widget.hutang,
                            ),
                            Text(
                              'Detail Transaksi',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.15,
                              ),
                            ),
                            FutureBuilder<List<KeranjangModel>>(
                              future: databaseService!.allDataKar(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.length == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50, bottom: 50),
                                      child: Center(
                                        child: Text("DATA KOSONG"),
                                      ),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0),
                                    child: Container(
                                      width: size.width * 0.9,
                                      height: size.height * 0.2,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        padding:
                                            EdgeInsets.only(top: 10, left: 0),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return detail(
                                              snapshot.data![index].nama,
                                              snapshot.data![index].jumlah
                                                  .toString(),
                                              CurrencyFormat.convertToIdr(
                                                  snapshot.data![index].total,
                                                  0));
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
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Container(
                                width: size.width * 0.8,
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
                            ),
                            totals(
                              'Subtotal',
                              CurrencyFormat.convertToIdr(widget.subtotal, 0),
                            ),
                            totals(
                              'Pembayaran Awal',
                              CurrencyFormat.convertToIdr(widget.pembayaranAwal, 0),
                            ),
                            totals(
                              'Ongkir',
                              CurrencyFormat.convertToIdr(widget.ongkir, 0),
                            ),
                            totals(
                              'Lain - Lain',
                              CurrencyFormat.convertToIdr(widget.lain, 0),
                            ),
                            totals(
                              'Potongan',
                              CurrencyFormat.convertToIdr(widget.potongan, 0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: totals(
                                'Total',
                                CurrencyFormat.convertToIdr(widget.total, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // IconButton(
            //   onPressed: () {
            //     print("sdsda");
            //     // Navigator.of(context).push(
            //     //     MaterialPageRoute(builder: (context) {
            //     //   return PdfPreviewScreen(
            //     //     namatransaksi: widget.namatransaksi,
            //     //     namapembeli: widget.namapembeli,
            //     //     pembayaran: widget.pembayaran,
            //     //     tanggal: widget.tanggal,
            //     //     subtotal: widget.subtotal,
            //     //     lain: widget.lain,
            //     //     ongkir: widget.ongkir,
            //     //     potongan: widget.potongan,
            //     //     total: widget.total,
            //     //     kode_invoice: widget.kode_invoice,
            //     //     hutang: widget.hutang,
            //     //   );
            //     // }));
            //   },
            //   icon: Icon(
            //     Icons.print,
            //     color: Colors.white,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PdfPreviewScreen(
                      namatransaksi: widget.namatransaksi,
                      namapembeli: widget.namapembeli,
                      pembayaran: widget.pembayaran,
                      tanggal: widget.tanggal,
                      subtotal: widget.subtotal,
                      lain: widget.lain,
                      ongkir: widget.ongkir,
                      potongan: widget.potongan,
                      total: widget.total,
                      kode_invoice: widget.kode_invoice,
                      hutang: widget.hutang,
                      pembayaranAwal: widget.pembayaranAwal,
                    );
                  }));
                },
                child: Container(
                  width: 327,
                  height: 45,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
                  decoration: ShapeDecoration(
                    color: Color(0xFF3F51B5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: () async {
                  await transaksiController.deleteKer(widget.kode_invoice, widget.total, widget.pembayaran);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 327,
                  height: 45,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
                  decoration: ShapeDecoration(
                    color: Color(0xFF3F51B5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selesai',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
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
                    'Direktorat Riset, Teknologi, dan Pengabdian Kepada Masyarakat, Direktorat\nJenderal Pendidikan Tinggi, Riset dan Teknologi, Kementrian Pendidikan,\nKebudayaan, Riset, dan Teknologi Republik Indonesia Tahun Pendanaan 2023',
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

  Padding totals(txt, hrg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            hrg,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Padding detail(ttl, pcs, total) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ttl,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${pcs} x',
                style: TextStyle(
                  color: Color(0xFFA8A8A8),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          Text(
            total,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Column text(Size size, ttl, value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ttl,
              style: TextStyle(
                color: Color(0xFFA8A8A8),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Container(
            width: size.width * 0.8,
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
        )
      ],
    );
  }
}
