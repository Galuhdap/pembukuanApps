import 'package:fajarjayaspring_app/API/pdf_invoice.dart';
import 'package:fajarjayaspring_app/controllers/pdfController.dart';
import 'package:fajarjayaspring_app/models/penjualan_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/customer_model.dart';
import '../../models/invoice_model.dart';
import '../../models/suplaier_model.dart';

class PdfviewDetailScreen extends StatefulWidget {
  final PenjualanModel? penjualanModel;

  const PdfviewDetailScreen({super.key, this.penjualanModel});

  @override
  State<PdfviewDetailScreen> createState() => _PdfviewDetailScreenState();
}

class _PdfviewDetailScreenState extends State<PdfviewDetailScreen> {
  PdfController pdfController = PdfController();
  PdfInvoiceApi pdfInvoiceApi = PdfInvoiceApi();


  List datas = [];
  List penj = [];
  List users = [];

  Future getDatas() async {
    datas = await pdfController.alls();
    List penjj = await pdfController.all(widget.penjualanModel!.nama_pembeli ?? '');
    users = await pdfController.user();
    setState(() {
      penj =penjj;
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

  List<InvoiceItem> items =  penj.map((category) {
      return InvoiceItem(
        description: category['produk'],
        quantity: category['jumlah_produk'],
        total: category['total_produk'],
      );
    }).toList();

    final invoice = Invoice(
      supplier: Supplier(
        name: users.length > 0 ? users[0]['nama'] : "",
        address: users.length > 0 ? users[0]['alamat'] : "",
      ),
      customer: Customer(
        judul:  widget.penjualanModel!.nama ?? '',
        name:  widget.penjualanModel!.nama_pembeli ?? '',
      ),
      info: InvoiceInfo(
        date: DateTime.parse(widget.penjualanModel!.createdAt ?? '') ,
        pay:  widget.penjualanModel!.pembayaran?? '',
      ),
      items: items,
      sub: InvoiceSub(
          subtotal:  widget.penjualanModel!.subtotal ?? 0,
          ongkir: widget.penjualanModel!.ongkos_kirim ?? 0,
          lain:  widget.penjualanModel!.biaya_lain ?? 0,
          potongan: widget.penjualanModel!.potongan_harga ?? 0,
          total: widget.penjualanModel!.total ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => pdfInvoiceApi.generate(invoice),
        pdfFileName: 'asdasd/Struck.pdf',
      ),
    );
  }
}
