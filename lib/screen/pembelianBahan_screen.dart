import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/models/pembelian_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/pembelianController.dart';
import '../data/format.dart';
import '../widget/appBarCos.dart';
import '../widget/transaction_card.dart';

class PembelianbahanScreen extends StatefulWidget {
  const PembelianbahanScreen({super.key});

  @override
  State<PembelianbahanScreen> createState() => _PembelianbahanScreenState();
}

class _PembelianbahanScreenState extends State<PembelianbahanScreen> {
  PembelianController pembelianController = PembelianController();
  DatabaseService? databaseService;

  TextEditingController namaController = TextEditingController();
  TextEditingController jmlhController = TextEditingController();
  TextEditingController satuanController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(locale: 'ID', decimalDigits: 0, name: '');

  DateTime? selectedDate;

  TextEditingController tglController = TextEditingController(
      text: DateFormat(' dd MMMM yyyy', 'id_ID')
          .format(DateTime.now())
          .toString());

  Future initDatabase() async {
    await databaseService!.database();
    setState(() {});
  }

  Future delete(int id, int hrg) async {
    await pembelianController.delete(idParams: id, harga: hrg);
    setState(() {});
  }

  String query = "";
  int harga = 0;

  String namaError = '';
  String jmlhError = '';
  String satuanError = '';
  String hargaError = '';

  void validateAndSave() async {
    setState(() {
      namaError = namaController.text.isEmpty ? 'Nama harus diisi' : '';
      jmlhError = jmlhController.text.isEmpty ? 'Jumlah harus diisi' : '';
      satuanError = satuanController.text.isEmpty ? 'Satuan harus diisi' : '';
      hargaError = hargaController.text.isEmpty ? 'Harga harus diisi' : '';
    });

    if (namaError.isEmpty &&
        jmlhError.isEmpty &&
        satuanError.isEmpty &&
        hargaError.isEmpty) {
      String hargaText =
          hargaController.text.replaceAll('Rp ', '').replaceAll('.', '');

      int parsedHarga = int.tryParse(hargaText) ?? 0;

      setState(() {
        harga = parsedHarga;
      });

      await pembelianController.insert(
          nama_barang: namaController.text,
          jmlh_brng: int.parse(jmlhController.text),
          satuan: satuanController.text,
          harga: harga);

      namaController.clear();
      jmlhController.clear();
      satuanController.clear();
      hargaController.clear();
      Navigator.pop(context);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              'Masukan Input Dengan Benar !!',
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseService = DatabaseService();

    initDatabase();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    namaController.dispose();
    jmlhController.dispose();
    satuanController.dispose();
    hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Column(
              children: [
                appbarCos(size, "Pembelihan Bahan", () {
                  Navigator.pop(context);
                }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 16,
                          offset: Offset(0, 0),
                          spreadRadius: -6,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 30,
                        left: 30,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.9,
                            height: 40,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                              enabled: true,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color(0xFFA8A8A8),
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Daftar Pembelian ',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              children: [
                                Text('Tanggal Transaksi: '),
                                TextButton(
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null &&
                                        picked != selectedDate) {
                                      setState(() {
                                        selectedDate = picked;
                                      });
                                    }
                                  },
                                  child: Text(
                                    selectedDate == null
                                        ? 'Pilih Tanggal'
                                        : DateFormat('dd MMM yyyy')
                                            .format(selectedDate!),
                                  ),
                                ),
                                if (selectedDate != null)
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        selectedDate = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<PembelianModel>>(
                  future: databaseService!.allData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 235, bottom: 280),
                          child: Center(
                            child: Text("DATA KOSONG"),
                          ),
                        );
                      }
                      final List<PembelianModel> filteredData =
                          snapshot.data!.where((item) {
                        final itemDate =
                            DateTime.parse(item.createdAt.toString());

                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(itemDate);

                        DateTime? kosong = null;

                        final formattedDates = selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(selectedDate!.toString()))
                            : kosong;

                        return item.nama_barang!
                                .toLowerCase()
                                .contains(query.toLowerCase()) &&
                            (formattedDates == null ||
                                formattedDate == formattedDates.toString());
                      }).toList();

                      return Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Container(
                          width: size.width * 0.9,
                          height: size.height * 0.6,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredData.length,
                            itemBuilder: (BuildContext context, index) {
                              return transactionCard2(
                                size,
                                filteredData[index].nama_barang,
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(DateTime.parse(filteredData[index]
                                        .createdAt
                                        .toString())),
                                filteredData[index].jmlh_brng.toString(),
                                filteredData[index].satuan,
                                '-${CurrencyFormat.convertToIdr(
                                    filteredData[index].harga, 0)}',
                                () {
                                  delete(snapshot.data![index].id!,
                                      snapshot.data![index].harga!);
                                 
                                },
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 15),
                  child: Column(
                    children: [
                      Text(
                        'DIDANAI OLEH:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 7)),
                      Text(
                        'Direktorat Riset, Teknologi, dan Pengabdian Kepada Masyarakat, Direktorat\nJenderal Pendidikan Tinggi, Riset dan Teknologi, Kementrian Pendidikan,\nKebudayaan, Riset, dan Teknologi Republik Indonesia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
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
            Positioned(
              top: size.height * 0.85,
              left: size.width * 0.77,
              child: InkWell(
                onTap: () async {
                  add(size);
                },
                child: Container(
                  width: 58,
                  height: 58,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: ShapeDecoration(
                            color: Color(0xFF3F51B5),
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 16,
                                offset: Offset(0, 0),
                                spreadRadius: -6,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future add(Size size) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              'Tambah Pembelian',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          content: Container(
            height: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.67,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFA8A8A8),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        "Tanggal",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.67,
                      height: 40,
                      child: TextField(
                        controller: tglController,
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        "Nama Barang",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.67,
                      height: 40,
                      child: TextField(
                        controller: namaController,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Text(
                            "Jumlah Pembelian",
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.43,
                          height: 40,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: jmlhController,
                            enabled: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(
                                  color: Color(0xFFA8A8A8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(
                                  color: Color(0xFFA8A8A8),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
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
                        Container(
                          width: size.width * 0.2,
                          height: 40,
                          child: TextField(
                            controller: satuanController,
                            enabled: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(
                                  color: Color(0xFFA8A8A8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(
                                  color: Color(0xFFA8A8A8),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        "Harga",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.67,
                      height: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: hargaController,
                        inputFormatters: [_currencyFormatter],
                        enabled: true,
                        decoration: InputDecoration(
                          prefixText: "Rp ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: 37,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50, color: Color(0xFF3F51B5)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Text(
                            "BATAL",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.3,
                        height: 37,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3F51B5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: validateAndSave,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
