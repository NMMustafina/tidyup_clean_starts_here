import 'package:flutter/material.dart';

abstract class Colorasdf {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFFDF4FF);
  static const Color appp = Color(0xFF1E1E1E);
  static const Color blue = Color(0xFF313BD4);
  static const Color purple = Color(0xFF8157D8);
  static const Color gradStart = Color(0xFFFF77FB);
  static const Color gradEnd = Color(0xFF8968FF);
  static const Color lightPurple = Color(0xFFBF90FF);
  static const Color lightBlue = Color(0xFF4F57EA);
  static const Color green = Color(0xFF008327);
  static const Color red = Color(0xFFE40000);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradStart, gradEnd],
  );
}
