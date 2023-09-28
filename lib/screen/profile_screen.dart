import 'package:fajarjayaspring_app/controllers/usersController.dart';
import 'package:fajarjayaspring_app/screen/home_screen.dart';
import 'package:fajarjayaspring_app/screen/profleedit_screen.dart';
import 'package:fajarjayaspring_app/widget/background.dart';
import 'package:fajarjayaspring_app/widget/textfield.dart';
import 'package:flutter/material.dart';

import '../config/db.dart';
import '../models/users_model.dart';

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

  Future fetchData() async {}

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
                      const EdgeInsets.only(left: 40, right: 45, bottom: 30),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.5),
                        child: Image.asset(
                          "assets/logo/tuturi.png",
                          width: 45.5,
                          height: 45.5,
                        ),
                      ),
                      Image.asset(
                        "assets/logo/untag.png",
                        width: 42,
                        height: 42,
                      ),
                      Image.asset(
                        "assets/logo/logounesa.png",
                        width: 41.5,
                        height: 41.5,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.85,
                  height: 555,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FutureBuilder<List>(
                    future: usersController.all(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        final List<UserModel> users =
                            snapshot.data!.map((item) {
                          return UserModel(
                              id: item['id'],
                              nama: item['nama'],
                              notelp: item['notelp'],
                              email: item['email'],
                              alamat: item['alamat'],
                              prov: item['prov'],
                              kota: item['kota']);
                        }).toList();

                        if (users.isNotEmpty) {
                          namaController.text = users[0].nama.toString();
                          notelpController.text = users[0].notelp.toString();
                          emailController.text = users[0].email.toString();
                          alamatController.text = users[0].alamat.toString();
                          provController.text = users[0].prov.toString();
                          kotaController.text = users[0].kota.toString();
                        }
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 1, right: 1, top: 25),
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
                              fieldText(
                                size,
                                'Nama Usaha',
                                false,
                                namaController,
                                TextInputType.text,
                                null,
                                '',
                                (value) {
                                  
                                },
                              ),
                              fieldText(
                                size,
                                'No Telp',
                                false,
                                notelpController,
                                TextInputType.number,
                                null,
                                '',
                                (value) {
                                  
                                },
                              ),
                              fieldText(
                                size,
                                'Email',
                                false,
                                emailController,
                                TextInputType.text,
                                null,
                                '',
                                (value) {
                                  
                                },
                              ),
                              fieldText(
                                size,
                                'Alamat',
                                false,
                                alamatController,
                                TextInputType.text,
                                null,
                                '',
                                (value) {
                                  
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textField2(
                                    size,
                                    'Provinsi',
                                    false,
                                    provController,
                                    TextInputType.text,
                                    (value) {
                                      
                                    },
                                  ),
                                  textField2(
                                    size,
                                    'Kota/Kabupaten',
                                    false,
                                    kotaController,
                                    TextInputType.text,
                                    (value) {
                                      
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
                        'Direktorat Riset, Teknologi, dan Pengabdian Kepada Masyarakat, Direktorat Jenderal Pendidikan Tinggi, Riset dan Teknologi, Kementrian Pendidikan, Kebudayaan, Riset, dan Teknologi Republik Indonesia Tahun Pendanaan 2023',
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
