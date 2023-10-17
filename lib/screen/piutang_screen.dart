import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fajarjayaspring_app/controllers/pengeluaranController.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';
import 'package:fajarjayaspring_app/screen/pdf/pdfViewPageDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/db.dart';
import '../data/format.dart';
import '../models/penjualan_model.dart';
import '../widget/appBarCos.dart';
import '../widget/transaction_card.dart';
import 'detail_piutang_screen.dart';

class PiutangScreen extends StatefulWidget {
  const PiutangScreen({super.key});

  @override
  State<PiutangScreen> createState() => _PiutangScreenState();
}

class _PiutangScreenState extends State<PiutangScreen> {
  DatabaseService? databaseService;

  PengeluaranController pengeluaranController = PengeluaranController();

  int harga = 0;
  CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(locale: 'ID', decimalDigits: 0, name: '');

  TextEditingController namaController = TextEditingController();
  TextEditingController biayaController = TextEditingController();

  TextEditingController tglController = TextEditingController(
      text: DateFormat(' dd MMMM yyyy', 'id_ID')
          .format(DateTime.now())
          .toString());

  String query = "";
  DateTime? selectedDate;
  final _formState = GlobalKey<FormState>();
  DateTime? _date;

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  Future delete(int id) async {
    await pengeluaranController.delete2(idParams: id);
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
  void dispose() {
    // TODO: implement dispose
    namaController.dispose();
    biayaController.dispose();
    tglController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              appbarCos(size, "Hutang", () {
                Navigator.pop(context);
              }),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: size.width,
                  height: 150,
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
                          child: TextFormField(
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
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daftar Hutang ',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Row(
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
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    setState(() {
                                      selectedDate = picked;
                                    });
                                  }
                                },
                                child: Text(
                                  selectedDate == null
                                      ? 'Pilih Tanggal'
                                      : DateFormat('dd MMM yyyy')
                                          .format(selectedDate!),
                                ),
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
                ),
              ),
              Column(
                children: [
                  FutureBuilder<List<PenjualanModel>>(
                    future: databaseService!.hutangPen(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length == 0) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.24,
                                bottom: size.height * 0.32),
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
                              item.kode_invoice
                                      .toString()
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) &&
                                  (formattedDates == null ||
                                      formattedDate ==
                                          formattedDates.toString());
                        }).toList();
                        return Padding(
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Container(
                            width: size.width * 0.9,
                            height: size.height * 0.6,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 10),
                              itemCount: filteredData.length,
                              itemBuilder: (BuildContext context, index) {
                                return transactionCard4(
                                  size,
                                  filteredData[index].nama.toString(),
                                  filteredData[index].kode_invoice.toString(),
                                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                      .format(DateTime.parse(filteredData[index]
                                          .createdAt
                                          .toString())),
                                  '-${CurrencyFormat.convertToIdr(filteredData[index].total, 0)}',
                                  () {
                                    delete(
                                        filteredData[index].id!);
                                  },
                                  () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return DetailPiutangScreen(
                                            penjualanModel: filteredData[index],
                                          );
                                        },
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  Color.fromARGB(255, 177, 0, 0),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        print(snapshot.error);
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01),
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
            ],
          ),
        ],
      ),
    );
  }

  Future add(Size size) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Center(
            child: Text(
              'Tambah Pembelian',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          content: Form(
            key: _formState,
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
                        "Tanggal",
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
                      child: TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return "Text Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        controller: tglController,
                        enabled: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today),
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
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _date ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (picked != null) {
                            setState(() {
                              tglController.text =
                                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                      .format(picked);

                              _date = picked;
                            });
                          }
                        },
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
                        "Nama Pengeluaran",
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
                      child: TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return "Text Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: namaController,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        "Harga",
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
                      child: TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return "Text Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [_currencyFormatter],
                        controller: biayaController,
                        enabled: true,
                        decoration: InputDecoration(
                          prefixText: "Rp ",
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
                            if (_formState.currentState!.validate()) {
                              String hargaText = biayaController.text
                                  .replaceAll('Rp ', '')
                                  .replaceAll('.', '');

                              int parsedHarga = int.tryParse(hargaText) ?? 0;

                              setState(() {
                                harga = parsedHarga;
                              });
                              await pengeluaranController.insert(
                                  nama_pengeluaran: namaController.text,
                                  biaya: harga,
                                  tgl: _date != null
                                      ? _date.toString()
                                      : DateTime.now().toString());
                              namaController.clear();
                              biayaController.clear();
                              Navigator.pop(context);
                              setState(() {});
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
