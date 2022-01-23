import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color mainAppColor = Color(0xFF273c75);
const Color landingPageBackgroundColor = Color(0xFFf5f6fa);
const Color bottomNavigationBarColor = Color(0xFFdfe4ea);
const Color addButtonColor = Color(0xFF6a89cc);

TextStyle get headingStyle {
  return GoogleFonts.lato (
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    )
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.oswald (
    textStyle: const TextStyle(
      fontSize: 16,
    )
  );
}

TextStyle get textFormTitleStyle {
  return GoogleFonts.lato (
    textStyle: const TextStyle(
      fontSize: 16,
    )
  );
}

TextStyle get textFormInputStyle {
  return GoogleFonts.lato (
    textStyle: const TextStyle(
      fontSize: 14,
    )
  );
}

TextStyle get headingStyleTwo {
  return GoogleFonts.lato (
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    )
  );
}

TextStyle get subHeadingStyleTwo {
  return GoogleFonts.lato (
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    )
  );
}

TextStyle get subHeadingStyleThree {
  return GoogleFonts.lato (
    textStyle: const TextStyle(
      fontSize: 14,
      fontStyle: FontStyle.italic,
      color: Colors.black,
    )
  );
}

TextStyle get showTimeStyle {
  return GoogleFonts.oswald (
    textStyle: const TextStyle(
      fontSize: 15,
      color: Colors.black,
      backgroundColor: Colors.white
    )
  );
}

// Selected Color
Color fillOne = const Color(0xFF686de0);
Color fillTwo = const Color(0xFFff7979);
Color fillThree = const Color(0xFFf6e58d);