import 'package:fajarjayaspring_app/controllers/usersController.dart';
import 'package:fajarjayaspring_app/screen/home_screen.dart';
import 'package:fajarjayaspring_app/screen/profleedit_screen.dart';
import 'package:fajarjayaspring_app/widget/background.dart';
import 'package:fajarjayaspring_app/widget/textfield.dart';
import 'package:flutter/material.dart';

import '../config/db.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseService databaseService = DatabaseService();

  UsersController usersController = UsersController();

  List data = [];

  TextEditingController namaController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController provController = TextEditingController();
  TextEditingController kotaController = TextEditingController();

  Future fetchData() async {
    List datas = await usersController.all();
    setState(() {
      data = datas;

      if (datas.isNotEmpty) {
        namaController.text = data[0]['nama'];
        notelpController.text = data[0]['notelp'];
        emailController.text = data[0]['email'];
        alamatController.text = data[0]['alamat'];
        provController.text = data[0]['prov'];
        kotaController.text = data[0]['kota'];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
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
                  padding:
                      const EdgeInsets.only(left: 40, right: 45, bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () {
                              Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Profile Usaha",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builde) {
                                return ProfileeditScreen();
                              },
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Container(
                          width: 77,
                          height: 28,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(width: 0.50, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'UBAH',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  height: 550,
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
                        fieldText(size, 'Nama Usaha', false, namaController,
                            TextInputType.text, null, ''),
                        fieldText(size, 'No Telp', false, notelpController,
                            TextInputType.number, null, ''),
                        fieldText(size, 'Email', false, emailController,
                            TextInputType.text, null,''),
                        fieldText(size, 'Alamat', false, alamatController,
                            TextInputType.text, null,''),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textField2(size, 'Provinsi', false, provController,
                                TextInputType.text),
                            textField2(size, 'Kota/Kabupaten', false,
                                kotaController, TextInputType.text),
                          ],
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
                        Padding(padding: EdgeInsets.only(bottom: 7)),
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
