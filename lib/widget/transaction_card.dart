import 'package:flutter/material.dart';

Padding transactionCard(ttl, tgl, rp, hapus, Size size) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Stack(
      children: [
        Container(
          width: 342,
          height: 72,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 16,
              offset: Offset(0, 0),
              spreadRadius: -6,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    ttl,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tgl,
                      style: TextStyle(
                        color: Color(0xFFA8A8A8),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      rp,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF1EB927),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: size.width * 0.765,
          top: size.height * 0.01,
          child: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: hapus,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        "Hapus",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
            child: Icon(
              Icons.more_vert,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}

Padding transactionCard3(Size size, ttl, tgl, rp, hapus, ontp) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: ontp,
      child: Stack(
        children: [
          Container(
            width: 342,
            height: 72,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 16,
                offset: Offset(0, 0),
                spreadRadius: -6,
              )
            ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(
                      ttl,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tgl,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        rp,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFFE91616),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.765,
            top: size.height * 0.01,
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: hapus,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          "Hapus",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
              child: Icon(
                Icons.more_vert,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Padding transactionCard2(Size size, ttl, tgl, kg, stn, rp, hapus) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Stack(
      children: [
        Container(
          width: 342,
          height: 77,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 16,
              offset: Offset(0, 0),
              spreadRadius: -6,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    ttl,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          kg,
                          style: TextStyle(
                            color: Color(0xFFA8A8A8),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        stn,
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tgl,
                      style: TextStyle(
                        color: Color(0xFFA8A8A8),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      rp,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFFE91616),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: size.width * 0.765,
          top: size.height * 0.01,
          child: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: hapus,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        "Hapus",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
            child: Icon(
              Icons.more_vert,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}

Padding productCard(Size size, ttl, tgl, kg, rp, stn, edit, hapus) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Stack(
      children: [
        Container(
          width: 342,
          height: 77,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 16,
              offset: Offset(0, 0),
              spreadRadius: -6,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Image.asset(
                        "assets/logo/boxs.png",
                        width: 34,
                        height: 34,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            ttl,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            kg,
                            style: TextStyle(
                              color: Color(0xFFA8A8A8),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tgl,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Text(
                        "Stock: ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        rp,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 2)),
                      Text(
                        stn,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: size.width * 0.765,
          top: size.height * 0.01,
          child: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: edit,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7, top: 7),
                      child: Text(
                        "Edit",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: hapus,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        "Hapus",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
            child: Icon(
              Icons.more_vert,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}

Padding productCard2(ttl, tgl, kg, rp, stn, ink, Size size) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Stack(
      children: [
        Container(
          width: 342,
          height: 77,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 16,
              offset: Offset(0, 0),
              spreadRadius: -6,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Image.asset(
                        "assets/logo/boxs.png",
                        width: 34,
                        height: 34,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            ttl,
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            kg,
                            style: TextStyle(
                              color: Color(0xFFA8A8A8),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tgl,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Text(
                        "Stock: ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        rp,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 2)),
                      Text(
                        stn,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: size.width * 0.73,
          top: 7,
          child: InkWell(
            onTap: ink,
            child: Container(
              width: 32,
              height: 32,
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
                size: 25,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Padding contText(Size size, ttl, rp) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width * 0.87,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.20,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFFA8A8A8),
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          ttl,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 5)),
        Text(
          rp,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
