import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../data/format.dart';
import '../models/LaporanLaba_model.dart';
import '../models/users_model.dart';

class PdfLaporanLaba {
  //ini untuk pdf flutter
  Future<Uint8List> generate(LaporanLaba invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),

        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle('Laporan Penjualan ' , invoice),
        buildTabelPenjualan(invoice),
         Divider(),
         totals3(invoice),
         SizedBox(height: 2 * PdfPageFormat.cm),
                 SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle('Laporan Hutang' , invoice),
        buildTabelHutangPenjualan(invoice),
         Divider(),

        buildTotals(invoice),
       
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return pdf.save();
  }

  //ini untuk header
  static Widget buildHeader(LaporanLaba invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Center(
            child: buildJudul(invoice.userModel),
          ),
        ],
      );

  static Widget totals3(LaporanLaba lprn) => Column(
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
          Text('Laporan Keuangan Laba/Kotor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          Text(users.nama.toString(), style: TextStyle(fontSize: 18)),
          Text(users.alamat.toString(), style: TextStyle(fontSize: 15)),
          Text( DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.now()).toString(), style: TextStyle(fontSize: 15)),
        ],
      );

  // ini buat Judul
  static Widget buildTitle(ttl, LaporanLaba invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ttl,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat('MMMM yyyy', 'id_ID').format(invoice.all.tgl).toString(),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );



  static Widget buildTabelPenjualan(LaporanLaba invoice) {
    final headers = [
      'Tanggal',
      'Nama',
      'Nama Barang',
      'Jmlh Beli',
      'Harga',
    ];
    final data = invoice.items.map((item) {
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

  static Widget buildTabelHutangPenjualan(LaporanLaba invoice) {
    final headers = [
      'Tanggal',
      'Nama',
      'Nama Barang',
      'Total',
      'Jatuh Tempo',
    ];
    final data = invoice.itemsHutang.map((item) {
      return [
       DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.parse(item.createdAt.toString())),
        item.nama,
        item.produk,
        CurrencyFormat.convertToIdr(item.total, 0),
        DateFormat(' dd MMMM yyyy', 'id_ID').format(DateTime.parse(item.jatuh_tempo.toString())),
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
  static Widget buildFooter(LaporanLaba invoice) => Column(
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

   static Widget buildTotals(LaporanLaba invoice) {
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
                  title: 'Keuntungan Kotor',
                  value: CurrencyFormat.convertToIdr(invoice.all.keuntungankotor, 0),
                  unite: true,
                ),
                buildText(
                  title: 'Keuntungan Bersih',
                  value: CurrencyFormat.convertToIdr(invoice.all.keuntunganbersih, 0),
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
