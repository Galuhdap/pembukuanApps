import 'package:fajarjayaspring_app/API/pdf_laporanPengeluaran.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/models/LaporanPengeluaran_model.dart';

import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';

import 'package:fajarjayaspring_app/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PDFLaporanPengeluaranScreen extends StatefulWidget {
  final int pemblihanbahan;
  final int pengeluaran;
  final int total;
  const PDFLaporanPengeluaranScreen({
    super.key,
    required this.pemblihanbahan,
    required this.pengeluaran,
    required this.total,
  });

  @override
  State<PDFLaporanPengeluaranScreen> createState() =>
      _PDFLaporanPengeluaranScreenState();
}

class _PDFLaporanPengeluaranScreenState
    extends State<PDFLaporanPengeluaranScreen> {
  PdfController pdfController = PdfController();
  PdfLaporanPengeluaran pdfLaporanPengeluaran = PdfLaporanPengeluaran();

  List datas = [];
  List penj = [];
  List pem = [];
  List peng = [];
  List users = [];

  Future getDatas() async {
    datas = await pdfController.allPenjualan();
    List pems = await pdfController.allPem();
    List pengs = await pdfController.allPeng();
    users = await pdfController.user();
    setState(() {
      pem = pems;
      peng = pengs;
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
    List<PembelianModel> itemsPembelian = pem.map((category) {
      return PembelianModel(
        createdAt: category['createdAt'],
        nama_barang: category['nama_barang'],
        jmlh_brng: category['jmlh_brng'],
        satuan: category['satuan'],
        harga: category['harga'],
      );
    }).toList();

    List<PengeluaranModel> itemsPengeluaran = peng.map((category) {
      return PengeluaranModel(
        createdAt: category['createdAt'],
        nama_pengeluaran: category['nama_pengeluaran'],
        biaya: category['biaya'],
      );
    }).toList();

    final laporan = LaporanPengeluaran(
        userModel: UserModel(nama: users.length > 0 ? users[0]['nama'] : "", alamat: users.length > 0 ? users[0]['alamat'] : ""),
        items: itemsPembelian,
        itemsPengeluaran: itemsPengeluaran,
        all: Alls(pemblihanbahan: widget.pemblihanbahan, pengeluaran: widget.pengeluaran, total: widget.total));

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdfLaporanPengeluaran.generate(laporan),
        pdfFileName: 'asdasd/Struck.pdf',
      ),
    );
  }
}
