
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:client/core/maestro_test_interceptor.dart';
import 'package:client/core/maestro_test_url.dart';

abstract class MaestroTestHttps {
  static const _timeOutMilli = 8000;

  static final _dio = Dio();

  static final _requestList = <String>[];

  bool get working => _requestList.isNotEmpty;

  bool get resting => _requestList.isEmpty;

  @mustCallSuper
  MaestroTestHttps() {
    setBaseSetting();
  }

  @mustCallSuper
  static void setBaseSetting({bool force = false}) {

    _dio.options = _baseOptionBuilder(baseUrl: SzsTestUrl.baseUrl);

    _dio.interceptors
      ..clear()
      ..add(DioInterceptor());
  }

  static BaseOptions _baseOptionBuilder({required String baseUrl}) =>
      BaseOptions(
          sendTimeout: const Duration(milliseconds: _timeOutMilli),
          receiveTimeout: const Duration(milliseconds: _timeOutMilli),
          connectTimeout: const Duration(milliseconds: _timeOutMilli),
          contentType: Headers.jsonContentType,
          baseUrl: baseUrl);

  @nonVirtual
  void dispose() {
    _dio.interceptors.clear();
    _requestList.clear();
    _dio.close(force: false);
  }

  @nonVirtual
  Future<Response<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic> queries = const {},
  }) async {
    _requestList.add(path);
    return _dio.get(path,
        queryParameters: queries)
      ..whenComplete(() {
        _requestList.remove(path);
      });
  }
}

