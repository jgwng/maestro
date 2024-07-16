import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/core/maestro_test_http.dart';
import 'package:client/helper/maestro_db_helper.dart';
import 'package:universal_html/html.dart' as html;
Future<void> initAppSetting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  MaestroTestHttps.setBaseSetting();
  if (kIsWeb) {
    html.document.onContextMenu.listen((event) => event.preventDefault());
  }
  await MaestroDBHelper().initDB();
}
