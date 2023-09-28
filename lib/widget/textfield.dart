import 'package:flutter/material.dart';

Padding fieldText(Size size, ttl, e, cntrl, key, nt, pt, validat) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Text(
            ttl,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: size.width * 0.75,
          child: TextFormField(
            validator: validat,
            controller: cntrl,
            keyboardType: key,
            inputFormatters: nt,
            enabled: e,
            decoration: InputDecoration(
              prefixText: pt,
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
  );
}

Padding textField2(Size size, ttl, e, ctrl, key, valida) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 19),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 26, bottom: 5),
          child: Text(
            ttl,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            width: size.width * 0.32,
            child: TextFormField(
              
              validator: valida,
              controller: ctrl,
              keyboardType: key,
              enabled: e,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(
                    color: Color(0xFFA8A8A8),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(
                    color: Color(0xFFA8A8A8),
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
              ),
              style: TextStyle(fontSize: 13.0, color: Colors.black),
            ),
          ),
        )
      ],
    ),
  );
}

Column textfieldpop(Size size, String ttl1) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 10),
        child: Text(
          ttl1,
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
  );
}
