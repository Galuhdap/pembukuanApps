import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fajarjayaspring_app/controllers/transactionController.dart';
import 'package:fajarjayaspring_app/models/keranjang_model.dart';
import 'package:fajarjayaspring_app/screen/catatanpenjualanAdd_screen.dart';
import 'package:fajarjayaspring_app/widget/appBarCos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/db.dart';
import '../data/format.dart';
import 'detail_screen.dart';

class CatatanpenjualanScreen extends StatefulWidget {
  const CatatanpenjualanScreen({super.key});

  @override
  State<CatatanpenjualanScreen> createState() => _CatatanpenjualanScreenState();
}

class _CatatanpenjualanScreenState extends State<CatatanpenjualanScreen> {
  DatabaseService? databaseService;
  TransaksiController transaksiController = TransaksiController();

  String nama = '';

var finals;

  var subtotals;

  int ongkirs = 0;
  int biayas = 0;
  int potonganH = 0;
  int? datas;
  int ongkir = 0;
  int byn = 0;
  int awalPembayaran = 0;
  int potongan = 0;

  int total = 0;
  String _value = 'Tunai';
  bool isTextFieldVisible = false;

  CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(locale: 'ID', decimalDigits: 0, name: '');

  TextEditingController namaController = TextEditingController();
  TextEditingController tglController = TextEditingController(
      text: DateFormat(' dd MMMM yyyy', 'id_ID')
          .format(DateTime.now())
          .toString());
  TextEditingController namapemController = TextEditingController();
  TextEditingController ongkirController = TextEditingController();
  TextEditingController biayaController = TextEditingController();
  TextEditingController awalPembayaranController = TextEditingController();
  TextEditingController potonganController = TextEditingController();
  TextEditingController tglHutangController = TextEditingController();

  final _formState = GlobalKey<FormState>();
  DateTime? _date;
  DateTime? _dates;

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  Future delete(int id) async {
    await transaksiController.delete(idParams: id);
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
    namapemController.dispose();
    ongkirController.dispose();
    biayaController.dispose();
    potonganController.dispose();
    tglController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    String invoice = 'KI-';

    for (int i = 0; i < 5; i++) {
      invoice += random.nextInt(10).toString();
    }
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formState,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              appbarCos(size, "Catat Penjualan", () {
                Navigator.pop(context);
              }),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        "Nama Transaksi",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return "Text Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        controller: namaController,
                        onChanged: (value) {
                          setState(() {
                            nama = value;
                          });
                        },
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
                    width: size.width * 0.8,
                    height: 40,
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
                        suffixIcon: Icon(Icons.calendar_today),
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
                      "Nama Pembeli",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: TextFormField(
                      validator: (value) {
                        if (value == '') {
                          return "Text Tidak Boleh Kosong";
                        }
                        return null;
                      },
                      controller: namapemController,
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
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produk',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builde) {
                                  return CatatanpenjualanAddScreen();
                                },
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: 53,
                            height: 25,
                            decoration: ShapeDecoration(
                              color: Color(0xFF2196F3),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50, color: Color(0xFF2196F3)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'TAMBAH',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              FutureBuilder<List<KeranjangModel>>(
                future: databaseService!.allDataKar(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: Center(
                          child: Text("DATA KOSONG"),
                        ),
                      );
                    }
                    return Container(
                      width: size.width * 0.8,
                      height: size.height * 0.23,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) {
                          return product(
                              size,
                              snapshot.data![index].nama,
                              snapshot.data![index].jumlah.toString(),
                              CurrencyFormat.convertToIdr(
                                  snapshot.data![index].total, 0), () {
                            delete(snapshot.data![index].id!);
                          });
                        },
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Ongkos Kirim",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: TextFormField(
                      inputFormatters: [_currencyFormatter],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            ongkir = 0;
                          } else {
                            String hargaText =
                                value.replaceAll('Rp ', '').replaceAll('.', '');

                            int parsedHarga = int.tryParse(hargaText) ?? 0;

                            ongkir = parsedHarga;
                          }
                        });
                      },
                      controller: ongkirController,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Biaya Lain-lain (Opsional)",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: TextFormField(
                      inputFormatters: [_currencyFormatter],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            byn = 0;
                          } else {
                            String hargaText =
                                value.replaceAll('Rp ', '').replaceAll('.', '');

                            int parsedHarga = int.tryParse(hargaText) ?? 0;

                            byn = parsedHarga;
                          }
                        });
                      },
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Potongan Harga (Opsional)",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: TextFormField(
                      inputFormatters: [_currencyFormatter],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            potongan = 0;
                          } else {
                            String hargaText =
                                value.replaceAll('Rp ', '').replaceAll('.', '');

                            int parsedHarga = int.tryParse(hargaText) ?? 0;

                            potongan = parsedHarga;
                          }
                        });
                      },
                      controller: potonganController,
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
                padding: const EdgeInsets.only(top: 30, bottom: 15),
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
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    FutureBuilder<int>(
                        future: transaksiController.subtotal(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else {
                            subtotals = snapshot.data;

                            return Text(
                              CurrencyFormat.convertToIdr(subtotals, 0),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ongkir',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(ongkir == 0 ? 0 : ongkir, 0),
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lain - Lain',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(byn == 0 ? 0 : byn, 0),
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Potongan',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(
                          potongan == 0 ? 0 : potongan, 0),
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    FutureBuilder<int>(
                      future: transaksiController.subtotal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          final int? data = snapshot.data;
                          final num subtotal = data ?? 0;
                          finals = subtotal + ongkir + byn - potongan - awalPembayaran;
                        
                          return Text(
                            CurrencyFormat.convertToIdr(finals , 0),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Pembayaran',
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 20),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                            value: 'Tunai',
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value!;
                                isTextFieldVisible = false;
                                tglHutangController.clear();
                                _dates = null;
                              });
                            }),
                        Text(
                          'Tunai',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                            value: 'Transfer',
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value!;
                                isTextFieldVisible = false;
                                tglHutangController.clear();
                                _dates = null;
                              });
                            }),
                        Text(
                          'Transfer',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: 'Hutang',
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value.toString();
                                isTextFieldVisible = true;
                              });
                            }),
                        Text(
                          'Piutang',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isTextFieldVisible)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Tanggal Jatuh Tempo",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Container(
                        width: size.width * 0.8,
                        child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              return "Text Tidak Boleh Kosong";
                            }
                            return null;
                          },
                          controller: tglHutangController,
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
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _dates ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (picked != null) {
                              setState(() {
                                tglHutangController.text =
                                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(picked);

                                _dates = picked;
                              });
                            }
                          },
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (isTextFieldVisible)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        "Pembayaran Awal",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: TextFormField(
                        inputFormatters: [_currencyFormatter],
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              awalPembayaran = 0;
                            } else {
                              String hargaText =
                                  value.replaceAll('Rp ', '').replaceAll('.', '');
              
                              int parsedHarga = int.tryParse(hargaText) ?? 0;
              
                              awalPembayaran = parsedHarga;
                            }
                          });
                        },
                        controller: awalPembayaranController,
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
              ),
              Container(
                width: size.width * 0.75,
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
                      String ongkirText = ongkirController.text
                          .replaceAll('Rp ', '')
                          .replaceAll('.', '');
                      String biayaText = biayaController.text
                          .replaceAll('Rp ', '')
                          .replaceAll('.', '');
                      String potoText = potonganController.text
                          .replaceAll('Rp ', '')
                          .replaceAll('.', '');

                      int parsedongkir = int.tryParse(ongkirText) ?? 0;
                      int parsedbaiay = int.tryParse(biayaText) ?? 0;
                      int parsedpotong = int.tryParse(potoText) ?? 0;

                      setState(() {
                        ongkirs = parsedongkir;
                        biayas = parsedbaiay;
                        potonganH = parsedpotong;
                      });

                      await transaksiController.insertpenjualan(
                          nama: namaController.text,
                          nama_pembeli: namapemController.text,
                          subtotal: subtotals ?? 0,
                          biaya_lain: biayas,
                          ongkos_kirim: ongkirs,
                          potongan_harga: potonganH,
                          pembayaran: _value,
                          total: finals,
                          idP: 1,
                          tgl: _date != null
                              ? _date.toString()
                              : DateTime.now().toString(),
                          kode_invoice: invoice.toString(),
                          jatuh_tempo: _dates != null ? _dates.toString() : "",
                          pemAwal: awalPembayaran,
                          );


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builde) {
                            return DetailScreen(
                              namatransaksi: namaController.text,
                              namapembeli: namapemController.text,
                              pembayaran: _value,
                              tanggal: _date != null
                                  ? _date.toString()
                                  : DateTime.now().toString(),
                              subtotal: subtotals ?? 0,
                              lain: byn,
                              ongkir: ongkir,
                              potongan: potongan,
                              total: finals,
                              kode_invoice: invoice.toString(),
                              hutang: _dates != null
                                  ? DateFormat('dd MMMM yyyy', 'id_ID')
                                      .format(DateTime.parse(_dates.toString()))
                                  : "",
                              pembayaranAwal: awalPembayaran,
                            );
                          },
                        ),
                      ).then((value) {
                        setState(() {});
                      });
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
              Padding(
                padding: const EdgeInsets.only(bottom: 7, top: 35),
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
                    Padding(padding: EdgeInsets.only(bottom: 7)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding product(Size size, nama, jml, total, ontp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: size.width * 0.8,
        height: 30,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.25, color: Color(0xFFA8A8A8)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nama,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                jml,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                total,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: ontp,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE91616),
                    shape: OvalBorder(),
                  ),
                  child: Icon(
                    Icons.delete,
                    size: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
