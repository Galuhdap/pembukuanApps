import 'package:flutter/material.dart';

Center PoinCard(Size size, ttl, kas, ontap) {
  return Center(
    child: Stack(
      children: [
        Container(
          width: size.width,
          height: 196,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment(0.90, -0.43),
              begin: Alignment(-0.9, 0.43),
              colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Image.asset(
                                "assets/logo/tuturi.png",
                                width: 33,
                                height: 33,
                              ),
                            ),
                            Image.asset(
                              "assets/logo/untag.png",
                              width: 30,
                              height: 30,
                            ),
                            Image.asset(
                              "assets/logo/logounesa.png",
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                       
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/logo/emoji.png",
                            width: 45,
                            height: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  ttl,
                                  style: TextStyle(
                                    color: Color(0xFFF5F5F5),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.15,
                                  ),
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
          Padding(
            padding: const EdgeInsets.only(left: 33, top: 155),
            child: InkWell(
              onTap: ontap,
              child: Container(
                width: size.width * 0.85,
                height: 85,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 16,
                      offset: Offset(0, 0),
                      spreadRadius: -6,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/logo/wallet.png",
                        width: 37,
                        height: 37,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo Sekarang',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.15,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 3)),
                            Text(
                              kas,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          
        ),
      ],
    ),
  );
}
