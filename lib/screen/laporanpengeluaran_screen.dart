import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/controllers/pengeluaranController.dart';
import 'package:fajarjayaspring_app/screen/pdf/pdfLaporanPengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/pembelianController.dart';
import '../controllers/produkController.dart';
import '../data/format.dart';
import '../widget/transaction_card.dart';

class LaporanpengeluaranScreen extends StatefulWidget {
  const LaporanpengeluaranScreen({super.key});

  @override
  State<LaporanpengeluaranScreen> createState() =>
      _LaporanpengeluaranScreenState();
}

class _LaporanpengeluaranScreenState extends State<LaporanpengeluaranScreen> {
  ProdukController produkController = ProdukController();
  PembelianController pembelianController = PembelianController();
  PengeluaranController pengeluaranController = PengeluaranController();
  PdfController pdfController = PdfController();

  List pengeluaran = [];
  List pembelian = [];
  List peng = [];
  List pem = [];
  int total = 0;
  String query = "";

  DateTime? selectedDate;

  Future fetchData() async {
    List pembelians = await pembelianController.all();
    List pengeluarans = await pengeluaranController.all();
    int totals = await pengeluaranController.totalKeseluruhan2();
    setState(() {
      pembelian = pembelians;
      pengeluaran = pengeluarans;
      peng = pengeluarans;
      pem = pembelians;
      total = totals;
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
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(selectedDate!.toString()))
        : kosong;

    List<NumericData> numericDataList = [
      NumericData(domain: 1, measure: 50000),
      NumericData(domain: 5, measure: 53000),
      NumericData(domain: 10, measure: 150000),
      NumericData(domain: 15, measure: 87000),
      NumericData(domain: 20, measure: 200000),
      NumericData(domain: 25, measure: 55000),
      NumericData(domain: 30, measure: 1300000),
    ];

    final numericGroupList = [
      NumericGroup(
        id: '1',
        data: numericDataList,
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Tanggal Transaksi: '),
                            TextButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
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
                                        : DateFormat('dd MMM yyyy')
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
                  )
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
                                    return PDFLaporanPengeluaranScreen(
                                          pengeluaran:  pengeluaran.length > 0
                                          ? (pengeluaran[0] != null
                                              ? (pengeluaran[0]['biaya'] ?? 0)
                                              : 0)
                                          : 0,
                                          pemblihanbahan:  pembelian.length > 0
                                          ? (pembelian[0] != null
                                              ? (pembelian[0]['harga'] ?? 0)
                                              : 0)
                                          : 0,
                                          total: total,
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
                                        left: 12, right: 12),
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
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder<int>(
                                future: selectedDate == null
                                    ? pengeluaranController.totalPeng()
                                    : pengeluaranController
                                        .filterDataByDatePeng(
                                            formattedDates.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    final bersih = snapshot.data ?? 0;
                                    return FutureBuilder<int>(
                                      future: selectedDate == null
                                          ? pengeluaranController.totalBahan()
                                          : pengeluaranController
                                              .filterDataByDateBahan(
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
                            ],
                          ),
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? pengeluaranController.totalPeng()
                              : pengeluaranController.filterDataByDatePeng(
                                  formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Pengeluaran",
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0));
                            }
                          },
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? pengeluaranController.totalBahan()
                              : pengeluaranController.filterDataByDateBahan(
                                  formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Pembelian Bahan",
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0));
                            }
                          },
                        ),
                        FutureBuilder<int>(
                          future: selectedDate == null
                              ? pengeluaranController.totalKeseluruhan()
                              : pengeluaranController
                                  .filterDataByDateKeseluruhan(
                                      formattedDates.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return contText(
                                  size,
                                  "Total Keseluruhan Pengeluaran",
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
                      padding: const EdgeInsets.only(bottom: 5, top: 35),
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
