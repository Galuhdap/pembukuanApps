 import 'package:flutter/material.dart';

Container appbarCos(Size size, ttl , ontap) {
    return Container(
              width: size.width,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment(0.90, -0.43),
                  begin: Alignment(-0.9, 0.43),
                  colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: ontap,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          ttl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Image.asset(
                            "assets/logo/tuturi.png",
                            width: 31,
                            height: 31,
                          ),
                        ),
                        Image.asset(
                          "assets/logo/untag.png",
                          width: 28,
                          height: 28,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Image.asset(
                            "assets/logo/logounesa.png",
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
            );
  }