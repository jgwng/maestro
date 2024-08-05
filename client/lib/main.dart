import 'package:client/business_logic/bloc/favorite_bloc.dart';
import 'package:client/business_logic/bloc/search_bloc.dart';
import 'package:client/core/maestro_routes.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:client/init_setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        )
      ],
      child: ValueListenableBuilder(
        valueListenable: MaestroThemeHelper.themeMode,
        builder: (context,mode,child){
          return GetMaterialApp(
            title: '마에스트로 패드',
            navigatorKey: navigatorKey,
            darkTheme: MaestroThemeHelper.dark,
            theme: MaestroThemeHelper.light,
            themeMode: mode,
            getPages: AppPages.pages,
            initialRoute: AppRoutes.home,
          );
        }),
    );
  }
}

