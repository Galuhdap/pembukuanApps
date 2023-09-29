import 'package:fajarjayaspring_app/API/pdf_laporanPengeluaran.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/models/LaporanPengeluaran_model.dart';

import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:fajarjayaspring_app/models/pengeluaran_model.dart';

import 'package:fajarjayaspring_app/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class PDFLaporanPengeluaranScreen extends StatefulWidget {
  final int pemblihanbahan;
  final int pengeluaran;
  final int total;
  final DateTime? selectedDate;
  const PDFLaporanPengeluaranScreen({
    super.key,
    required this.pemblihanbahan,
    required this.pengeluaran,
    required this.total,
    required this.selectedDate,
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
  List _pengeluaran = [];
  List _pembelian = [];

  // DateTime? selectedDate;

  Future filterDatas() async {
    DateTime? kosong = null;
    final formattedDates = widget.selectedDate != null
        ? DateFormat('yyyy-MM')
            .format(DateTime.parse(widget.selectedDate!.toString()))
        : kosong;

    List pengeluarans = await (widget.selectedDate == null
        ? pdfController.laporanPengeluaranAll()
        : pdfController
            .filterDataBylaporanPengeluaran(formattedDates.toString()));

    List pembelians = await (widget.selectedDate == null
        ? pdfController.laporanpembelianAll()
        : pdfController
            .filterDataBylaporanPembelian(formattedDates.toString()));

    setState(() {
      _pengeluaran = pengeluarans;
      _pembelian = pembelians;
    });
  }

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
    filterDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PembelianModel> itemsPembelian = _pembelian.map((category) {
      return PembelianModel(
        createdAt: category['createdAt'],
        nama_barang: category['nama_barang'],
        jmlh_brng: category['jmlh_brng'],
        satuan: category['satuan'],
        harga: category['harga'],
      );
    }).toList();

    List<PengeluaranModel> itemsPengeluaran = _pengeluaran.map((category) {
      return PengeluaranModel(
        createdAt: category['createdAt'],
        nama_pengeluaran: category['nama_pengeluaran'],
        biaya: category['biaya'],
      );
    }).toList();

    final laporan = LaporanPengeluaran(
        userModel: UserModel(
            nama: users.length > 0 ? users[0]['nama'] : "",
            alamat: users.length > 0 ? users[0]['alamat'] : ""),
        items: itemsPembelian,
        itemsPengeluaran: itemsPengeluaran,
        all: Alls(
          pemblihanbahan: widget.pemblihanbahan,
          pengeluaran: widget.pengeluaran,
          total: widget.total,
          tgl: widget.selectedDate ?? DateTime.now(),
        ));

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
