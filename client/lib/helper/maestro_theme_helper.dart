import 'package:client/core/maestro_const.dart';
import 'package:client/core/maestro_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:universal_html/html.dart' as html;
class MaestroThemeHelper {
  static final MaestroThemeHelper instance = MaestroThemeHelper._internal();
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static bool get isDark => themeMode.value == ThemeMode.dark;
  static ThemeMode get currentMode => (isDark) ? ThemeMode.dark : ThemeMode.light;

  factory MaestroThemeHelper() => instance;
  MaestroThemeHelper._internal();
  static final ThemeData light = ThemeData(
    primaryColorLight: const Color.fromRGBO(239, 241, 243, 1.0),
    primaryColorDark: const Color(0xff222222),
    secondaryHeaderColor: const Color.fromRGBO(234, 235, 237, 1.0),
    textTheme: lightTextTheme,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: const Color.fromRGBO(250,250,250,1.0),
    fontFamilyFallback: AppFonts.fontFamilyFallback,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 12, // Set your desired font size
            fontWeight: FontWeight.bold, // Set your desired font weight
            color: Colors.white, // Set your desired text color
          ),
      ),
    )),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black,
        textTheme: ButtonTextTheme.normal,
      ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Color(0xff222222)
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppThemes.pointColor,
      unselectedItemColor: AppThemes.unSelectedColor,
    ),

  );
  static final ThemeData dark = ThemeData(
    textTheme: darkTextTheme,
      primaryColorDark: const Color.fromRGBO(239, 241, 243, 1.0),
      primaryColorLight: const Color(0xff222222),
      secondaryHeaderColor: const Color.fromRGBO(40, 40, 40, 1.0),
    splashFactory: NoSplash.splashFactory,
    fontFamilyFallback: AppFonts.fontFamilyFallback,
    scaffoldBackgroundColor: const Color.fromRGBO(60, 60, 60, 1.0),
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.normal,
    ),
    textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor:  Color.fromRGBO(239, 241, 243, 1.0)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 12, // Set your desired font size
              fontWeight: FontWeight.bold, // Set your desired font weight
              color: Colors.black, // Set your desired text color
            ),
          ),
        )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(22,22,22,1.0),
        selectedItemColor: Color.fromRGBO(237,237,237,1.0),
        unselectedItemColor: Color.fromRGBO(111,111,111,1.0),
      )
  );

  static const TextTheme lightTextTheme = TextTheme(
    displaySmall: TextStyle(
        fontSize: 12,
        color: Color.fromRGBO(0, 0, 0, 1.0),
        fontWeight: FontWeight.w500,
        fontFamily: AppFonts.medium),
    displayMedium: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(0, 0, 0, 1.0),
          fontFamily: AppFonts.bold),
      bodyMedium: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(0, 0, 0, 1.0),
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.medium),
    displayLarge: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(0, 0, 0, 1.0),

        fontFamily: AppFonts.bold),
      labelLarge: TextStyle(
          fontFamily: AppFonts.medium,
          fontSize: 18,
          height: 24/18,
          letterSpacing: -0.6,
        color: Color.fromRGBO(250, 250, 250, 1.0)),
      bodySmall: TextStyle(
        color: Color.fromRGBO(108, 108, 108, 1.0),
        fontFamily: AppFonts.medium,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      )
  );

  static const TextTheme darkTextTheme = TextTheme(
    displaySmall: TextStyle(
        fontSize: 12,
        color: Color.fromRGBO(250, 250, 250, 1.0),
        fontWeight: FontWeight.w500,
        fontFamily: AppFonts.medium),
      displayMedium: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(250, 250, 250, 1.0),
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.bold),
    displayLarge: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(250, 250, 250, 1.0),
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.bold),
    bodyMedium: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(250, 250, 250, 1.0),
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.medium),
    labelLarge: TextStyle(
        fontFamily: AppFonts.medium,
        fontSize: 18,
        height: 24/18,
        letterSpacing: -0.6,
        color: Color.fromRGBO(0, 0, 0, 1.0)),
      bodySmall: TextStyle(
        color: Color.fromRGBO(116, 116, 116, 1.0),
        fontFamily: AppFonts.medium,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      )
  );

  static void init() async{
    if(kIsWeb){
      String mode = (html.window.localStorage[MaestroConst.CURRENT_THEME_STYLE] ?? MaestroConst.LIGHT_THEME).toUpperCase();
      _setThemeMode(mode!);
      html.window.onMessage.listen((event) {
        String? mode = event.data ?? MaestroConst.LIGHT_THEME;
        _setThemeMode(mode!);
      });
    }else{
      var box = Hive.box(MaestroConst.THEME_MODE_DATA);
      var mode = await box.get(MaestroConst.CURRENT_THEME_STYLE);
      if(mode == null){
        mode = MaestroConst.LIGHT_THEME;
        box.put(MaestroConst.CURRENT_THEME_STYLE, mode);
      }
      _setThemeMode(mode);
    }
  }

  static void _setThemeMode(String mode){
    if(mode == MaestroConst.DARK_THEME){
      themeMode.value = ThemeMode.dark;
    }else{
      themeMode.value = ThemeMode.light;
    }
  }

  static void change() {
    var box = Hive.box(MaestroConst.THEME_MODE_DATA);
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        box.put(MaestroConst.CURRENT_THEME_STYLE, MaestroConst.LIGHT_THEME);
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        box.put(MaestroConst.CURRENT_THEME_STYLE, MaestroConst.LIGHT_THEME);
        break;
      default:
    }
    // if(kIsWeb){
    //   String theme = themeMode.value.name.toUpperCase();
    //   js.context.callMethod('toggleDarkMode', [theme]);
    // }
  }
}