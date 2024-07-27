import 'package:client/core/maestro_routes.dart';
import 'package:flutter/material.dart';
import 'package:client/init_setting.dart';
import 'package:client/ui/main/screen/main_screen.dart';
import 'package:get/get.dart';

void main() async{
  await initAppSetting();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Maestro Test',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        getPages: AppPages.pages,
        initialRoute: AppRoutes.home,
    );
  }
}

