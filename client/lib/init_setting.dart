import 'dart:io';

import 'package:client/core/maestro_const.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/core/maestro_test_http.dart';
import 'package:client/helper/maestro_db_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:universal_html/html.dart' as html;
Future<void> initAppSetting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Hive.openBox(MaestroConst.THEME_MODE_DATA);
  MaestroThemeHelper.init();
  MaestroTestHttps.setBaseSetting();
  if (kIsWeb) {
    html.document.onContextMenu.listen((event) => event.preventDefault());
  }
  await MaestroDBHelper().initDB();
}
