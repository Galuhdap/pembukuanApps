import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:fajarjayaspring_app/screen/laporanlabarugi_screen.dart';
import 'package:fajarjayaspring_app/screen/laporanpengeluaran_screen.dart';
import 'package:fajarjayaspring_app/screen/laporansemua_screen.dart';
import 'package:flutter/material.dart';

import '../../widget/appBarCos.dart';

class TebBarScreen extends StatefulWidget {
  TebBarScreen({Key? key}) : super(key: key);

  @override
  _TebBarScreenState createState() => _TebBarScreenState();
}

class _TebBarScreenState extends State<TebBarScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            appbarCos(size, "Laporan", () {
              Navigator.of(context).pop();
            }),
            Container(
              width: size.width,
              height: 77,
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: ButtonsTabBar(
                    unselectedBorderColor: Color(0xFF3F51B5),
                    borderWidth: 1.3,
                    borderColor: Color(0xFF3F51B5),
                    backgroundColor: Color(0xFF3F51B5),
                    unselectedBackgroundColor: Color.fromARGB(255, 151, 168, 202),
                    unselectedLabelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                    height: 200,
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28, right: 28),
                          child: Text(
                            'Semua',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'Laba/Kotor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Pengeluaran',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  LaporansemuaScreen(),
                  LaporanlabarugiScreen(),
                  LaporanpengeluaranScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
