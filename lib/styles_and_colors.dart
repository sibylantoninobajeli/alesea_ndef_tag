library alesea_ndef_tag.styles;
import 'dart:ui';
import 'package:flutter/material.dart';



final aleseaLogoColor = const Color(0xff1e2353);
final aleseaPrimaryColor = const Color(0xff3a6b82);
final aleseaPrimaryVariantColor = const Color(0xff335d71);
final aleseaSecondaryColor = const Color(0xff6c757d);
final aleseaBackgroundColor = const Color(0xffeef0f2);
final aleseaDisabledColor = const Color(0xffb8bfc6);
final aleseaTextColor = const Color(0xff212529);
final aleseaSuccessColor = const Color(0xff7bba70);

TextStyle aleseaTextStyleRegularWhiteVeryBig = TextStyle(
    fontFamily: "Helvetica nueue regular",
    fontSize: 30.0,
    letterSpacing: 1.0,
    fontWeight: FontWeight.w700,
    color: Colors.white70);

TextStyle aleseaTextStyleRegularWhite = TextStyle(
    fontFamily: "Helvetica nueue regular",
    fontSize: 15.0,
    letterSpacing: 1.0,
    fontWeight: FontWeight.w700,
    color: Colors.white70);

Color getCheckboxColor(Set<MaterialState> states) {
const Set<MaterialState> interactiveStates = <MaterialState>{
MaterialState.pressed,
MaterialState.hovered,
MaterialState.focused,
};

if (states.any(interactiveStates.contains)) {
return Colors.blue;
}
if (states.contains(MaterialState.selected)) {
return aleseaSuccessColor;
}
return aleseaDisabledColor;
}