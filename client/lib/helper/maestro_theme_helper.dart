import 'package:client/core/maestro_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
class MaestroThemeHelper {
  static final MaestroThemeHelper instance = MaestroThemeHelper._internal();
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static bool get isDark => themeMode.value == ThemeMode.dark;
  static ThemeMode get currentMode => (isDark) ? ThemeMode.dark : ThemeMode.light;

  factory MaestroThemeHelper() => instance;
  MaestroThemeHelper._internal();
  static final ThemeData light = ThemeData(
    textTheme: textTheme,
    scaffoldBackgroundColor: const Color.fromRGBO(255,255,255,1.0),
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
    )

  );
  static final ThemeData dark = ThemeData(
    textTheme: textTheme,
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
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
  );

  static void init() async{
    if(kIsWeb){
      String mode = (html.window.localStorage['theme'] ?? 'DARK').toUpperCase();
      if(mode == 'DARK'){
        themeMode.value = ThemeMode.dark;
      }else{
        themeMode.value = ThemeMode.light;
      }

      html.window.onMessage.listen((event) {
        String? mode = event.data;
        if((mode ?? 'LIGHT') == 'LIGHT'){
          themeMode.value = ThemeMode.light;
        }else{
          themeMode.value = ThemeMode.dark;
        }
      });
    }
  }

  static void change() {
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        break;
      default:
    }
    // if(kIsWeb){
    //   String theme = themeMode.value.name.toUpperCase();
    //   js.context.callMethod('toggleDarkMode', [theme]);
    // }
  }
}