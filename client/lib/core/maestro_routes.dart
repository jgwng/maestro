import 'package:client/ui/detail/screen/detail_screen.dart';
import 'package:client/ui/login/login_screen.dart';
import 'package:client/ui/main/screen/main_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String login = '/';
  static String home = '/home';
  static String detail = '/detail';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen()
    ),
    GetPage(
      name: AppRoutes.home,
      page: () =>  const MainScreen(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () =>  const DetailScreen(),
    ),
  ];
}
