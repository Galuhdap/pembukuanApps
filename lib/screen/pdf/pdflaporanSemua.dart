import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/models/laporanSemua_model.dart';
import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../API/pdf_laporansemua.dart';

class PDFLaporanSemuaScreen extends StatefulWidget {
   final int kas;
  final int pemblihanbahan;
  final int pengeluaran;
  final int penjualan;
  final int total;
  const PDFLaporanSemuaScreen({super.key,  required this.kas,
    required this.pemblihanbahan,
    required this.pengeluaran,
    required this.penjualan,
    required this.total,});

  @override
  State<PDFLaporanSemuaScreen> createState() => _PDFLaporanSemuaScreenState();
}

class _PDFLaporanSemuaScreenState extends State<PDFLaporanSemuaScreen> {
  PdfController pdfController = PdfController();
  PdfLaporanSemua pdfLaporanSemua = PdfLaporanSemua();

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
      penj = datas;
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
    List<PenjualanModel> itemsPenjualans = penj.map((category) {
      return PenjualanModel(
        createdAt: category['createdAt'],
        nama: category['nama'],
        produk: category['produk'],
        jumlah_produk: category['jumlah_produk'],
        total_produk: category['total_produk'],
        total: category['total'],
      );
    }).toList();

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

    final laporan = LaporanSemua(
      userModel: UserModel(
          nama:  users.length > 0 ? users[0]['nama'] : "", 
          alamat: '${users.length > 0 ? (users[0]['alamat']) : ""} ${users.length > 0 ? (users[0]['kota']) : ""} ${users.length > 0 ? (users[0]['prov']) : ""}'),
      items: itemsPembelian,
      itemsPengeluaran: itemsPengeluaran,
      itemsPenjualan: itemsPenjualans,
      all: Alls(
          kas: widget.kas,
          pemblihanbahan: widget.pemblihanbahan,
          pengeluaran: widget.pengeluaran,
          // totalhpp: 2929,
          penjualan: widget.penjualan,
          total: widget.total),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdfLaporanSemua.generate(laporan),
        pdfFileName: 'LaporanSemua.${DateTime.now()}.pdf',
      ),
    );
  }
}
