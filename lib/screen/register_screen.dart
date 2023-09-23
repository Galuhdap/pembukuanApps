import 'package:fajarjayaspring_app/config/db.dart';
import 'package:fajarjayaspring_app/controllers/saldoController.dart';
import 'package:fajarjayaspring_app/widget/background.dart';
import 'package:fajarjayaspring_app/widget/textfield.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DatabaseService databaseService = DatabaseService();

  SaldoController saldoController = SaldoController();

  TextEditingController namaController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController provController = TextEditingController();
  TextEditingController kotaController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    databaseService.database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: backgroundApps(
        size,
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Hai, Daftarkan\nUsahamu Dulu Yuk!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  height: 600,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1, right: 1, top: 25),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/logo/logoapp.png",
                          width: 100,
                          height: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                        ),
                        fieldText(size, 'Nama Usaha', true, namaController,
                            TextInputType.text, null, ''),
                        fieldText(size, 'No Telp', true, notelpController,
                            TextInputType.phone, null, ''),
                        fieldText(size, 'Email', true, emailController,
                            TextInputType.text, null, ''),
                        fieldText(size, 'Alamat', true, alamatController,
                            TextInputType.text, null, ''),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textField2(size, 'Provinsi', true, provController,
                                TextInputType.text),
                            textField2(size, 'Kota/Kabupaten', true,
                                kotaController, TextInputType.text),
                          ],
                        ),
                        Container(
                          width: size.width * 0.75,
                          height: 37,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF3F51B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              String name = namaController.text;
                              String phoneNumber = notelpController.text;
                              String email = emailController.text;
                              String address = alamatController.text;
                              String prov = provController.text;
                              String kota = kotaController.text;

                              await databaseService.saveUserData(
                                status: true,
                                name: name,
                                phoneNumber: phoneNumber,
                                email: email,
                                address: address,
                                prov: prov,
                                kota: kota,
                              );

                              await saldoController.savesaldoData();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (builde) {
                                    return HomeScreen();
                                  },
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
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
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  child: Column(
                    children: [
                      Text(
                        'DIDANAI OLEH:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 7)),
                      Text(
                        'Direktorat Riset, Teknologi, dan Pengabdian Kepada Masyarakat, Direktorat Jenderal Pendidikan Tinggi, Riset dan Teknologi, Kementrian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
