import 'package:flutter/material.dart';
import '../data/colors.dart';

Container backgroundApps(Size size, p) {
  return Container(
    width: size.width,
    height: 870,
    decoration: BoxDecoration(
      color: backgroundApp,
      gradient: LinearGradient(
        begin: Alignment(0.90, -0.43),
        end: Alignment(-0.9, 0.43),
        colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
      ),
    ),
    child: p,
  );
}
