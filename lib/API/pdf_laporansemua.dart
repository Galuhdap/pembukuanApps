import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../data/format.dart';
import '../models/laporanSemua_model.dart';
import '../models/users_model.dart';

class PdfLaporanSemua {
  //ini untuk pdf flutter
  Future<Uint8List> generate(LaporanSemua invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle('Laporan Pembelian Bahan'),
        buildTabel(invoice),
        Divider(),
        totals(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle('Laporan Pengeluaran '),
        buildTabelPengeluaran(invoice),
        Divider(),
        totals2(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle('Laporan Penjualan '),
        buildTabelPenjualan(invoice),
         Divider(),
         totals3(invoice),
         SizedBox(height: 2 * PdfPageFormat.cm),
        Divider(),

        buildTotals(invoice),
       
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return pdf.save();
  }

  //ini untuk header
  static Widget buildHeader(LaporanSemua invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Center(
            child: buildJudul(invoice.userModel),
          ),
        ],
      );

  static Widget totals(LaporanSemua lprn) => Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CurrencyFormat.convertToIdr(lprn.all.pemblihanbahan, 0),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ]),
                )
              ],
            ),
          ),
        ],
      );
  static Widget totals2(LaporanSemua lprn) => Column(
        children: [
          Container(
            width: 475,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                Text(CurrencyFormat.convertToIdr(lprn.all.pengeluaran, 0),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ],
      );
  static Widget totals3(LaporanSemua lprn) => Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CurrencyFormat.convertToIdr(lprn.all.penjualan, 0),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ]),
                )
              ],
            ),
          ),
        ],
      );
//ini untuk judul
  static Widget buildJudul(UserModel users) => Column(
        children: [
          Text('Laporan Keuangan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          Text(users.nama.toString(), style: TextStyle(fontSize: 18)),
          Text(users.alamat.toString(), style: TextStyle(fontSize: 15)),
          Text( DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.now()).toString(), style: TextStyle(fontSize: 15)),
        ],
      );

  // ini buat Judul
  static Widget buildTitle(ttl) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ttl,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

// ini untuk Tabel
  static Widget buildTabel(LaporanSemua invoice) {
    final headers = [
      'Tanggal',
      'Nama Barang',
      'Jumlah Pembelian',
      'Satuan',
      'Harga',
    ];
    final data = invoice.items.map((item) {
      return [
        DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.parse(item.createdAt.toString())),
        item.nama_barang,
        item.jmlh_brng,
        item.satuan,
        CurrencyFormat.convertToIdr(item.harga, 0),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTabelPenjualan(LaporanSemua invoice) {
    final headers = [
      'Tanggal',
      'nama',
      'Nama Barang',
      'Jumlah Pembelian',
      'Harga',
    ];
    final data = invoice.itemsPenjualan.map((item) {
      return [
        DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.parse(item.createdAt.toString())),
        item.nama,
        item.produk,
        item.jumlah_produk,
        CurrencyFormat.convertToIdr(item.total, 0),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTabelPengeluaran(LaporanSemua invoice) {
    final headers = [
      'Tanggal',
      'Nama Barang',
      'Harga',
    ];
    final data = invoice.itemsPengeluaran.map((item) {
      return [
       DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.parse(item.createdAt.toString())),
        item.nama_pengeluaran,
        CurrencyFormat.convertToIdr(item.biaya, 0),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

//ini untuk kaki
  static Widget buildFooter(LaporanSemua invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address', value: invoice.userModel.alamat.toString()),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

   static Widget buildTotals(LaporanSemua invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Kas',
                  value: CurrencyFormat.convertToIdr(invoice.all.kas, 0),
                  unite: true,
                ),
                buildText(
                  title: 'Pembalian Bahan',
                  value: CurrencyFormat.convertToIdr(invoice.all.pemblihanbahan, 0),
                  unite: true,
                ),
                buildText(
                  title: 'Pengeluaran',
                  value: CurrencyFormat.convertToIdr(invoice.all.pengeluaran, 0),
                  unite: true,
                ),
                buildText(
                  title: 'Pemasukan',
                  value: CurrencyFormat.convertToIdr(invoice.all.penjualan, 0),
                  unite: true,
                ),
                // buildText(
                //   title: 'Total HPP',
                //   value: CurrencyFormat.convertToIdr(invoice.all.totalhpp, 0),
                //   unite: true,
                // ),
                Divider(),
                buildText(
                  title: 'Total Keseluruhan',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: CurrencyFormat.convertToIdr(invoice.all.total, 0),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
