import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fajarjayaspring_app/controllers/produkController.dart';
import 'package:fajarjayaspring_app/models/produk_model.dart';
import 'package:fajarjayaspring_app/widget/textfield.dart';
import 'package:flutter/material.dart';

import '../config/db.dart';
import '../widget/appBarCos.dart';

class DaftarprodukEditScreen extends StatefulWidget {
  final ProdukModel? produkModel;

  const DaftarprodukEditScreen({super.key, this.produkModel});

  @override
  State<DaftarprodukEditScreen> createState() => _DaftarprodukEditScreenState();
}

class _DaftarprodukEditScreenState extends State<DaftarprodukEditScreen> {
  DatabaseService databaseService = DatabaseService();

  ProdukController produkController = ProdukController();

  int harga = 0;
  int hargapokoks = 0;
  CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(locale: 'ID', decimalDigits: 0, name: '');

  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController hargapokokController = TextEditingController();
  TextEditingController hargajualController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController satuanController = TextEditingController();

  final _formState = GlobalKey<FormState>();

  String namaError = '';
  String hargaPokokError = '';
  String hargaJualError = '';
  String stockError = '';
  String satuanError = '';

  @override
  void initState() {
    // TODO: implement initState
    databaseService.database();
    namaController.text = widget.produkModel!.nama ?? '';
    deskripsiController.text = widget.produkModel!.deskripsi ?? '';
    skuController.text = widget.produkModel!.sku ?? '';
    hargapokokController.text =
        widget.produkModel!.harga_pokok?.toString() ?? '';
    hargajualController.text = widget.produkModel!.harga_jual?.toString() ?? '';
    stockController.text = widget.produkModel!.stock?.toString() ?? '';
    satuanController.text = widget.produkModel!.satuan ?? '';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    namaController.dispose();
    deskripsiController.dispose();
    skuController.dispose();
    hargapokokController.dispose();
    hargajualController.dispose();
    stockController.dispose();
    satuanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            appbarCos(size, "EDIT PRODUCT", () {
              Navigator.pop(context);
              setState(() {});
            }),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: ShapeDecoration(
                        color: Color(0xFFDEDEFF),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Container(
                    width: 115,
                    height: 115,
                    decoration: ShapeDecoration(
                      color: Color(0xFFDEDEFF),
                      shape: OvalBorder(),
                    ),
                  ),
                  Image.asset(
                    "assets/logo/boxs.png",
                    width: 80,
                    height: 80,
                  )
                ],
              ),
            ),
            Text(
              'EDIT PRODUCT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1, right: 1, top: 25),
              child: Form(
                key: _formState,
                child: Column(
                  children: [
                    fieldText(
                      size,
                      'Nama Produk',
                      true,
                      namaController,
                      TextInputType.text,
                      null,
                      '',
                      (value) {
                        if (value == '') {
                          return "Text Tidak Boleh Kosong";
                        }
                        return null;
                      },
                    ),
                    fieldText(
                      size,
                      'Deskripsi Produk',
                      true,
                      deskripsiController,
                      TextInputType.text,
                      null,
                      '',
                      (value) {},
                    ),
                    fieldText(
                      size,
                      'SKU (Opsional)',
                      true,
                      skuController,
                      TextInputType.text,
                      null,
                      '',
                      (value) {},
                    ),
                    fieldText(
                      size,
                      'Harga Pokok (HPP)',
                      true,
                      hargapokokController,
                      TextInputType.number,
                      [_currencyFormatter],
                      'Rp ',
                      (value) {
                        if (value == '') {
                          return "Text Tidak Boleh Kosong";
                        }
                        return null;
                      },
                    ),
                    fieldText(
                      size,
                      'Harga Jual',
                      true,
                      hargajualController,
                      TextInputType.number,
                      [_currencyFormatter],
                      'Rp ',
                      (value) {
                        if (value == '') {
                          return "Text Tidak Boleh Kosong";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 19),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 57, bottom: 5),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Container(
                                  width: size.width * 0.45,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == '') {
                                        return "Text Harus Diisi";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: stockController,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Color(0xFFA8A8A8),
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
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
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 19),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "Satuan",
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 51),
                                child: Container(
                                  width: size.width * 0.25,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == '') {
                                        return "Harus Diisi";
                                      }
                                      return null;
                                    },
                                    controller: satuanController,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Color(0xFFA8A8A8),
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
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
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
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
                      String hargaText = hargajualController.text
                          .replaceAll('Rp ', '')
                          .replaceAll('.', '');

                      int parsedHarga = int.tryParse(hargaText) ?? 0;

                      setState(() {
                        harga = parsedHarga;
                      });

                      String hargapokok = hargapokokController.text
                          .replaceAll('Rp ', '')
                          .replaceAll('.', '');

                      int parsedHargapokok = int.tryParse(hargapokok) ?? 0;

                      setState(() {
                        hargapokoks = parsedHargapokok;
                      });
                      await produkController.updateDatas(
                        nama: namaController.text,
                        deskripsi: deskripsiController.text,
                        sku: skuController.text,
                        stock: int.parse(stockController.text),
                        satuan: satuanController.text,
                        harga_jual: harga,
                        harga_pokok: hargapokoks,
                        idPar: widget.produkModel!.id!,
                      );
                      Navigator.pop(context);
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
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.01, bottom: size.height * 0.01),
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
    );
  }
}
