import 'package:fajarjayaspring_app/API/pdf_laporanLaba.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/models/LaporanLaba_model.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PDFLaporanLabaScreen extends StatefulWidget {
  final int keuntungankotor;
  final int keuntunganbersih;
  final int penjualan;
  const PDFLaporanLabaScreen({
    super.key,
    required this.keuntungankotor,
    required this.keuntunganbersih,
    required this.penjualan,
  });

  @override
  State<PDFLaporanLabaScreen> createState() => _PDFLaporanLabaScreenState();
}

class _PDFLaporanLabaScreenState extends State<PDFLaporanLabaScreen> {
  PdfController pdfController = PdfController();
  PdfLaporanLaba pdfLaporanLaba = PdfLaporanLaba();

  List datas = [];
  List penj = [];
  List users = [];

  Future getDatas() async {
    datas = await pdfController.allPenjualan();
    users = await pdfController.user();
    setState(() {
      penj = datas;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PenjualanModel> items = penj.map((category) {
      return PenjualanModel(
        createdAt: category['createdAt'],
        nama: category['nama'],
        produk: category['produk'],
        jumlah_produk: category['jumlah_produk'],
        total_produk: category['total_produk'],
        total: category['total'],
      );
    }).toList();

    final laporan = LaporanLaba(
      userModel: UserModel(
          nama: users.length > 0 ? users[0]['nama'] : "",
          alamat: users.length > 0 ? users[0]['alamat'] : ""),
      items: items,
      all: Alls(
        keuntungankotor: widget.keuntungankotor,
        keuntunganbersih: widget.keuntunganbersih,
        penjualan: widget.penjualan,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdfLaporanLaba.generate(laporan),
        pdfFileName: 'asdasd/Struck.pdf',
      ),
    );
  }
}
