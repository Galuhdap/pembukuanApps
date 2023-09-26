
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/controllers/pengeluaranController.dart';
import 'package:fajarjayaspring_app/controllers/transactionController.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/saldoPenjualan_model.dart';
import 'package:fajarjayaspring_app/screen/catatanpenjualan_screen.dart';
import 'package:fajarjayaspring_app/screen/home_screen.dart';
import 'package:fajarjayaspring_app/screen/pdf/pdfViewPageDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/db.dart';
import '../data/format.dart';
import '../widget/appBarCos.dart';
import '../widget/transaction_card.dart';

class PenjualanScreen extends StatefulWidget {
  const PenjualanScreen({super.key});

  @override
  State<PenjualanScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  PdfController pdfController = PdfController();
  DatabaseService? databaseService;

  DateTime? selectedDate;
  String query = "";

  PengeluaranController pengeluaranController = PengeluaranController();
  TransaksiController transaksiController = TransaksiController();

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  Future delete(String id, int totals) async {
    await transaksiController.deletePen(idParams: id, total: totals);
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
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Column(
              children: [
                appbarCos(size, "Penjualan", () {
                  Navigator.pop(context);

                }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: size.width,
                    height: 250,
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 30,
                        left: 30,
                      ),
                      child: Column(
                        children: [
                          Container(
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
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Daftar Penjualan',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.15,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Tanggal Transaksi: '),
                                      TextButton(
                                        onPressed: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                selectedDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (picked != null &&
                                              picked != selectedDate) {
                                            setState(() {
                                              selectedDate = picked;
                                            });
                                          }
                                        },
                                        child: Row(
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
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                'Total Penjualan ',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.15,
                                ),
                              )),
                          FutureBuilder<List>(
                              future: transaksiController.alls(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  final List<SaldopenjualanModel> saldos =
                                      snapshot.data!.map((item) {
                                    return SaldopenjualanModel(
                                      id: item['id'],
                                      total: item['total'] != null
                                          ? item['total']
                                          : 0.0,
                                    );
                                  }).toList();
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      CurrencyFormat.convertToIdr(
                                          saldos.length > 0
                                              ? saldos[0].total
                                              : 0,
                                          0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 32,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<PenjualanModel>>(
                  future: databaseService!.allPen(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 195, bottom: 245),
                          child: Center(
                            child: Text("DATA KOSONG"),
                          ),
                        );
                      }
                      final List<PenjualanModel> filteredData =
                          snapshot.data!.where((item) {
                        final itemDate =
                            DateTime.parse(item.createdAt.toString());

                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(itemDate);

                        DateTime? kosong = null;

                        final formattedDates = selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(selectedDate!.toString()))
                            : kosong;

                        return item.nama
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()) &&
                            (formattedDates == null ||
                                formattedDate == formattedDates.toString());
                      }).toList();
                      return Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Container(
                          width: size.width * 0.9,
                          height: size.height * 0.48,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredData.length,
                            itemBuilder: (BuildContext context, index) {
                              return transactionCard3(
                                size,
                                filteredData[index].nama.toString(),
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(DateTime.parse(filteredData[index]
                                        .createdAt
                                        .toString())),
                                '+${CurrencyFormat.convertToIdr(
                                    filteredData[index].total, 0)}',
                                () {
                                  delete(filteredData[index].nama!,
                                      filteredData[index].total!);
                                 
                                },
                                () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PdfviewDetailScreen(
                                          penjualanModel: filteredData[index],
                                        );
                                      },
                                    ),
                                  );  
                                },
                                Color(0xFF1EB927),
                                
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
                  padding: const EdgeInsets.only(bottom: 2, top:15),
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
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: size.height * 0.85,
              left: size.width * 0.77,
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builde) {
                        return CatatanpenjualanScreen();
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
