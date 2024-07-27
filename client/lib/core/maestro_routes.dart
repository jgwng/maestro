import 'package:client/ui/detail/screen/detail_screen.dart';
import 'package:client/ui/main/screen/main_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String home = '/';
  static String detail = '/detail';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () =>  MainScreen(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () =>  DetailScreen(),
    ),
  ];
}
