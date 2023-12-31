import 'package:fajarjayaspring_app/API/pdf_laporanLaba.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/models/LaporanLaba_model.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:fajarjayaspring_app/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class PDFLaporanLabaScreen extends StatefulWidget {
  final int keuntungankotor;
  final int keuntunganbersih;
  final int penjualan;
  final DateTime? selectedDate;

  const PDFLaporanLabaScreen({
    super.key,
    required this.keuntungankotor,
    required this.keuntunganbersih,
    required this.penjualan,
    required this.selectedDate,
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
  List _penjualan = [];

  // DateTime? selectedDate;

  DateTime? kosong = null;

  Future filterDatas() async {
    final formattedDates = widget.selectedDate != null
        ? DateFormat('yyyy-MM')
            .format(DateTime.parse(widget.selectedDate!.toString()))
        : kosong;

    List penjualans = await (widget.selectedDate == null
        ? pdfController.laporanPenjualanAll()
        : pdfController
            .filterDataBylaporanPenjualan(formattedDates.toString()));
    List hutang = await (widget.selectedDate == null
        ? pdfController.allHutang()
        : pdfController
            .filterDataBylaporanHutang(formattedDates.toString()));

    setState(() {
      _penjualan = penjualans;
      datasHutang = hutang;
    });
  }

  List datasHutang = [];

  Future getDatas() async {
    datas = await pdfController.allPenjualan();
    users = await pdfController.user();
    List _datashutang = await pdfController.allHutang();
    setState(() {
      penj = datas;
      
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
    List<PenjualanModel> items = _penjualan.map((category) {
      return PenjualanModel(
        createdAt: category['createdAt'],
        nama: category['nama'],
        produk: category['produk'],
        jumlah_produk: category['jumlah_produk'],
        total_produk: category['total_produk'],
        total: category['total'],
      );
    }).toList();

    List<PenjualanModel> itemsHutang = datasHutang.map((category) {
      return PenjualanModel(
          createdAt: category['createdAt'],
          nama: category['nama'],
          produk: category['produk'],
          jumlah_produk: category['jumlah_produk'],
          total: category['total'],
          jatuh_tempo: category['jatuh_tempo']);
    }).toList();

    final laporan = LaporanLaba(
      userModel: UserModel(
          nama: users.length > 0 ? users[0]['nama'] : "",
          alamat:
              '${users.length > 0 ? (users[0]['alamat']) : ""} ${users.length > 0 ? (users[0]['kota']) : ""} ${users.length > 0 ? (users[0]['prov']) : ""}'),
      items: items,
      itemsHutang: itemsHutang,
      all: Alls(
        keuntungankotor: widget.keuntungankotor,
        keuntunganbersih: widget.keuntunganbersih,
        penjualan: widget.penjualan,
        tgl: widget.selectedDate ?? DateTime.now(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdfLaporanLaba.generate(laporan),
        pdfFileName:
            'LaporanLabaKotor.${widget.selectedDate ?? DateTime.now()}.pdf',
      ),
    );
  }
}
