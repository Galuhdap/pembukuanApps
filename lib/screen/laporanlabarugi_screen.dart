import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/controllers/transactionController.dart';
import 'package:fajarjayaspring_app/screen/pdf/pdfLaporanLaba.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

import '../data/format.dart';
import '../widget/transaction_card.dart';

class LaporanlabarugiScreen extends StatefulWidget {
  const LaporanlabarugiScreen({super.key});

  @override
  State<LaporanlabarugiScreen> createState() => _LaporanlabarugiScreenState();
}

class _LaporanlabarugiScreenState extends State<LaporanlabarugiScreen> {
  DatabaseService databaseService = DatabaseService();
  TransaksiController transaksiController = TransaksiController();
  PdfController pdfController = PdfController();

  String query = "";

  DateTime? selectedDate;

  int kotor = 0;
  int bersih = 0;
  List pemasukan = [];

  Future fetchData() async {
    int kotorss = await pdfController.totalKotor();
    int bersihss = await pdfController.totalBersih();
    List pemasukans = await transaksiController.alls();

    setState(() {
      pemasukan = pemasukans;
      kotor = kotorss;
      bersih = bersihss;
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
    DateTime? kosong = null;
    final formattedDates = selectedDate != null
        ? DateFormat('yyyy-MM')
            .format(DateTime.parse(selectedDate!.toString()))
        : kosong;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 16,
                    offset: Offset(0, 0),
                    spreadRadius: -6,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Column(
                          children: [
                            Text('Tanggal Transaksi: '),
                            TextButton(
                              onPressed: () async {
                                final DateTime? picked =
                                    await DatePicker.showSimpleDatePicker(
                                  context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2090),
                                  dateFormat: "MMMM-yyyy",
                                  locale: DateTimePickerLocale.id,
                                  looping: true,
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    selectedDate == null
                                        ? 'Pilih Tanggal'
                                        : DateFormat('MMM yyyy')
                                            .format(selectedDate!),
                                  ),
                                  if (selectedDate != null)
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = null;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: size.width,
                height: 630,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 10),
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Statistik',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return PDFLaporanLabaScreen(
                                      keuntunganbersih: bersih,
                                      keuntungankotor: kotor,
                                      penjualan: pemasukan.length > 0
                                          ? (pemasukan[0] != null
                                              ? (pemasukan[0]['total'] ?? 0)
                                              : 0)
                                          : 0,
                                    );
                                  }));
                                },
                                child: Container(
                                  width: size.width * 0.17,
                                  height: 29,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF3F51B5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 11),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.file_download_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        Text(
                                          'PDF',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder<int>(
                                future: selectedDate == null
                                    ? transaksiController.totalBersih()
                                    : transaksiController
                                        .filterDataByDateBersih(
                                            formattedDates.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    final bersih = snapshot.data ?? 0;
                                    return FutureBuilder<int>(
                                      future: selectedDate == null
                                          ? transaksiController.totalKotor()
                                          : transaksiController
                                              .filterDataByDateKotor(
                                                  formattedDates.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else {
                                          final kotor = snapshot.data ?? 0;

                                          final ordinalDataList = [
                                            OrdinalData(
                                              domain: 'kotor',
                                              measure: kotor,
                                              color: Color(0xFFE91616),
                                            ),
                                            OrdinalData(
                                              domain: 'harga',
                                              measure: bersih,
                                              color: Color(0xFF2196F3),
                                            ),
                                          ];
                                          return Container(
                                            width: 200,
                                            height: 200,
                                            child: DChartPieO(
                                              data: ordinalDataList,
                                              configRenderPie:
                                                  const ConfigRenderPie(
                                                arcWidth: 30,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: size.width * 0.35,
                                    height: 65,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                      padding: const EdgeInsets.only(
                                          left: 13, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFF2196F3),
                                                  shape: OvalBorder(),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5)),
                                              Text(
                                                'Laba',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          FutureBuilder<int>(
                                            future: selectedDate == null
                                                ? transaksiController
                                                    .totalBersih()
                                                : transaksiController
                                                    .filterDataByDateBersih(
                                                        formattedDates
                                                            .toString()),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Text(
                                                    CurrencyFormat.convertToIdr(
                                                        snapshot.data ?? 0, 0),
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 15,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.15,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 15)),
                                  Container(
                                    width: size.width * 0.35,
                                    height: 65,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                      padding: const EdgeInsets.only(
                                          left: 13, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFFE91616),
                                                  shape: OvalBorder(),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5)),
                                              Text(
                                                'Kotor',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          FutureBuilder<int>(
                                            future: selectedDate == null
                                                ? transaksiController
                                                    .totalKotor()
                                                : transaksiController
                                                    .filterDataByDateKotor(
                                                        formattedDates
                                                            .toString()),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Text(
                                                    CurrencyFormat.convertToIdr(
                                                        snapshot.data ?? 0, 0),
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 15,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.15,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? transaksiController.totals()
                              : transaksiController
                                  .filterDataByDate(formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Penjualan",
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0));
                            }
                          },
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? transaksiController.ongkir()
                              : transaksiController.filterDataByDateOngkir(
                                  formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Total Biaya Kirim",
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0));
                            }
                          },
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? transaksiController.totalKotor()
                              : transaksiController.filterDataByDateKotor(
                                  formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Keuntungan Kotor",
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0));
                            }
                          },
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? transaksiController.totalBersih()
                              : transaksiController.filterDataByDateBersih(
                                  formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Keuntungan Bersih",
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0));
                            }
                          },
                        ),
                        Container(
                          width: size.width * 0.87,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.20,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFA8A8A8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 60),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding isiProKel(ttl, jmlh, hrg) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
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
            jmlh,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFA8A8A8),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            hrg,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFFA8A8A8),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
