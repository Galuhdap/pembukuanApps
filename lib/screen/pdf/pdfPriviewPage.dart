import 'package:fajarjayaspring_app/API/pdf_invoice.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/customer_model.dart';
import '../../models/invoice_model.dart';
import '../../models/suplaier_model.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String namatransaksi;
  final String namapembeli;
  final String tanggal;
  final String pembayaran;

  final int subtotal;
  final int ongkir;
  final int lain;
  final int potongan;
  final int total;
  PdfPreviewScreen(
      {super.key,
      required this.namatransaksi,
      required this.namapembeli,
      required this.tanggal,
      required this.pembayaran,
      required this.subtotal,
      required this.ongkir,
      required this.potongan,
      required this.lain,
      required this.total});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PdfController pdfController = PdfController();
  PdfInvoiceApi pdfInvoiceApi = PdfInvoiceApi();

  List datas = [];
  List users = [];

  Future getDatas() async {
    List datass = await pdfController.alls();
    users = await pdfController.user();
    setState(() {
      datas = datass;
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

  List<InvoiceItem> items =  datas.map((category) {
      return InvoiceItem(
        description: category['nama'],
        quantity: category['jumlah'] ?? 0,
        total: category['total'] ?? 0,
      );
    }).toList();

    final invoice = Invoice(
      supplier: Supplier(
        name: users.length > 0 ? users[0]['nama'] : "",
        address: users.length > 0 ? users[0]['alamat'] : "",
      ),
      customer: Customer(
        judul: widget.namatransaksi,
        name: widget.namapembeli,
      ),
      info: InvoiceInfo(
        date: DateTime.now(),
        pay: widget.pembayaran,
      ),
      items: items,
      sub: InvoiceSub(
          subtotal: widget.subtotal,
          ongkir: widget.ongkir,
          lain: widget.lain,
          potongan: widget.potongan,
          total: widget.total),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdfInvoiceApi.generate(invoice),
        pdfFileName: '${widget.namatransaksi}/Struck.pdf',
      ),
    );
  }
}