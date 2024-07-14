import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/core/maestro_test_http.dart';
import 'package:client/helper/maestro_db_helper.dart';

Future<void> initAppSetting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  MaestroTestHttps.setBaseSetting();
  await MaestroDBHelper().initDB();
}
