import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle customStyle(
      {required double fontSize,
      required FontWeight fontWeight,
      required Color color,
      FontStyle fontStyle = FontStyle.normal, // Default font family
      double letterSpacing = 0,
      List<Shadow> shadows = const [],
      double? height,
      decoration = TextDecoration.none}) {
    return GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: color,
        shadows: shadows,
        height: height ?? 0,
        decoration: decoration,
        letterSpacing: letterSpacing);
  }
}
