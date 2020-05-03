import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Text setMainTabText(String heading) {
  return Text(
    heading,
    style: GoogleFonts.fredokaOne(
      textStyle: TextStyle(fontSize: 30)
    ),
    textAlign: TextAlign.center
  );
}

Text setAppTitle(String title) {
  return Text(
    title,
    style: GoogleFonts.fredokaOne(
      textStyle: TextStyle(fontSize: 25)
    )
  );
}