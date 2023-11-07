import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayMedium: GoogleFonts.openSans(color: Colors.black87),
    titleSmall: GoogleFonts.lato(color: Colors.blueGrey, fontSize: 24),
  );
  static TextTheme darkTextTheme = TextTheme(
    displayMedium: GoogleFonts.openSans(color: Colors.white70),
    titleSmall: GoogleFonts.lato(color: Colors.white60, fontSize: 24),
  );
}
