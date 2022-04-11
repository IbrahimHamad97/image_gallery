import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
      appBarTheme: AppBarTheme(color: mainColor),
      brightness: Brightness.light,
      primaryColor: Colors.white,
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white);

  static final dark = ThemeData(
      appBarTheme: AppBarTheme(color: Colors.red),
      brightness: Brightness.dark,
      backgroundColor: Colors.black);
}

const textInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue)));

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length <= 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

Color mainColor = fromHex('#461f7a');
Color secondColor = fromHex('#c7ceea');