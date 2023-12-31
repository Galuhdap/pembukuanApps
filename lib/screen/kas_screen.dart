import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/controllers/kas_controller.dart';
import 'package:fajarjayaspring_app/controllers/saldoController.dart';
import 'package:fajarjayaspring_app/models/kas_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/format.dart';
import '../models/saldo_model.dart';
import '../widget/transaction_card.dart';

class KasScreen extends StatefulWidget {
  const KasScreen({super.key});

  @override
  State<KasScreen> createState() => _KasScreenState();
}

class _KasScreenState extends State<KasScreen> {
  DatabaseService? databaseService;
  KasController kasController = KasController();
  SaldoController saldoController = SaldoController();

  TextEditingController deskripsiController = TextEditingController();
  TextEditingController biayaController = TextEditingController();
  TextEditingController tglController = TextEditingController(
      text: DateFormat(' dd MMMM yyyy', 'id_ID')
          .format(DateTime.now())
          .toString());

  List saldos = [];
  int harga = 0;
  String query = "";
  final _formState = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? _date;
  CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(locale: 'ID', decimalDigits: 0, name: '');


  Future fetchData() async {
    List saldoss = await saldoController.all();
    setState(() {
      saldos = saldoss;
    });
  }

  Future delete(int id, int biaya) async {
    await kasController.delete(idParams: id, idP: 1, biaya: biaya);
    setState(() {});
  }

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseService = DatabaseService();
    initDatabase();
    fetchData();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    deskripsiController.dispose();
    biayaController.dispose();
    tglController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: size.width,
              height: 300,
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
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset(
                                    "assets/logo/tuturi.png",
                                    width: 33,
                                    height: 33,
                                  ),
                                ),
                                Image.asset(
                                  "assets/logo/untag.png",
                                  width: 29,
                                  height: 29,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Image.asset(
                                    "assets/logo/logounesa.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'Uang Kas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        FutureBuilder<int>(
                          future: saldoController.allKas(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  CurrencyFormat.convertToIdr(
                                      snapshot.data ?? 0, 0),
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
                          },
                        ),
                        Container(
                          width: 166,
                          height: 37,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF3F51B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              print('Ini Data: $_date');
                              add(size);
                            },
                            child: Text(
                              "TAMBAH KAS",
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
          FutureBuilder<List<KasModel>>(
            future: databaseService!.allDataKas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length == 0) {
                  return Padding(
                    padding:  EdgeInsets.only(top: size.height * 0.25, bottom: size.height * 0.255),
                    child: Center(
                      child: Text("DATA KOSONG"),
                    ),
                  );
                }
                final List<KasModel> filteredData =
                    snapshot.data!.where((item) {
                  final itemDate = DateTime.parse(item.createdAt.toString());
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(itemDate);

                  DateTime? kosong = null;

                  final formattedDates = selectedDate != null
                      ? DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(selectedDate!.toString()))
                      : kosong;

                  return item.deskripsi!
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      (formattedDates == null ||
                          formattedDate == formattedDates.toString());
                }).toList();
                return Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.53,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      itemCount: filteredData.length,
                      itemBuilder: (BuildContext context, index) {
                        return transactionCard(
                            filteredData[index].deskripsi,
                            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(
                                DateTime.parse(
                                    filteredData[index].createdAt.toString())),
                            '+${CurrencyFormat.convertToIdr(filteredData[index].biaya, 0)}',
                            () async {
                          delete(filteredData[index].id!,
                              filteredData[index].biaya!);
                        }, size);
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
            padding:  EdgeInsets.only(top: size.height * 0.01),
            child: Column(
              children: [
                Text(
                  'DIDANAI OLEH:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                    fontSize: 8,
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
              ],
            ),
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
              'Tambah Kas',
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
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
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
                        "Deskripsi Kas",
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
                        controller: deskripsiController,
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
                        "Biaya",
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
                        inputFormatters: [_currencyFormatter],
                        keyboardType: TextInputType.number,
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
                          onPressed: () async {
                            Navigator.of(context).pop();
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

                              await kasController.insert(
                                  deskripsi: deskripsiController.text,
                                  biaya: harga,
                                  idParams: 1,
                                  tgl: _date != null ?  _date.toString() : DateTime.now().toString());

                              deskripsiController.clear();
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
