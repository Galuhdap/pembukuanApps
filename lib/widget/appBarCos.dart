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
                        Image.asset(
                          "assets/logo/tuturi.png",
                          width: 30,
                          height: 30,
                        ),
                        Image.asset(
                          "assets/logo/untag.png",
                          width: 25,
                          height: 25,
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
              ),
            );
  }