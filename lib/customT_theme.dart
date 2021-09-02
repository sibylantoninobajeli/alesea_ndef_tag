import 'package:alesea_ndef_tag/styles_and_colors.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: aleseaPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.yellow,
        )
    );
  }
}