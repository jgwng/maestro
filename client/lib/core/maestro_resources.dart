import 'package:flutter/material.dart';

class AppFonts {
  static const String bold = 'SuiteBold';
  static const String medium = 'SuiteMedium';
  static const String emoji = 'NotoColorEmoji';
  static const List<String> fontFamilyFallback = [
    'Noto Sans SC',
    "Noto Sans Symbols",
    bold,
    medium,
    AppFonts.emoji
  ];
  static const String emojiUrl =
      'https://fonts.gstatic.com/s/notocoloremoji/v25/Yq6P-KqIXTD0t4D9z1ESnKM3-HpFab5s79iz64w.ttf';
}

class AppThemes {
  AppThemes._();
  static const Color textColor = Color(0xff222222);
  static const Color backgroundColor = Color(0xfffffafa);
  static const Color buttonColor = Color(0xff0BCE83);
  static const Color favoriteColor = Color(0xffff3a30);

  static const Color pointColor = Color.fromRGBO(28 ,28, 28,  1.0);
  static const Color unSelectedColor = Color.fromRGBO(234 ,235, 237,  1.0);

  static const Color disableColor = Color.fromRGBO(178, 178, 178, 1.0);
  static const Color noticeColor = Color.fromARGB(255, 77, 82, 86);
  static const Color hintColor = Color.fromARGB(255, 169, 175, 179);

  static const buttonTextColor = Color(0xFFF6F5EE);
  static const mobileBackgroundColor = Color.fromRGBO(238, 238, 241, 1.0);

  static const TextTheme textTheme = TextTheme(
    button: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: Colors.white),
    headline1: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    headline2: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    subtitle2: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    bodyText1: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
    bodyText2: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoMedium',
        color: buttonTextColor),
  );
}
