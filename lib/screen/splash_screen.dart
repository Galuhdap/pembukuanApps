import 'package:fajarjayaspring_app/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../config/db.dart';
import '../widget/background.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final DatabaseService databaseService = DatabaseService();

  Future<Map<String, dynamic>> getUserData() async {
    final Database _database = await databaseService.database();
    final data = await _database.query('users');

    if (data.isNotEmpty) {
      return data[0];
    } else {
      return {};
    }
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              FutureBuilder<Map<String, dynamic>>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data ?? {};

                final bool isRegistered = userData['status'] == 1;
                if (isRegistered) {
                  return HomeScreen();
                } else {
                  return RegisterScreen();
                }
              } 
              return Center();
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: backgroundApps(
        size,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Present By :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/logo/tuturi.png",
                        width: 45,
                        height: 45,
                      ),
                      Image.asset(
                        "assets/logo/untag.png",
                        width: 40,
                        height: 40,
                      ),
                      Image.asset(
                        "assets/logo/logounesa.png",
                        width: 45,
                        height: 45,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo/logoapp.png",
                      width: 139,
                      height: 150,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
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
    );
  }
}
