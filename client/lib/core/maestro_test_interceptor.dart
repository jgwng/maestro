import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/main.dart';

class DioInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['authorization'] = 'KakaoAK ${dotenv.env['API_KEY']}';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (data is Map) {
      bool success = response.statusCode == 200;
      if (!success) {
        handler.reject(
          DioException(requestOptions: response.requestOptions, response: response),
          true,
        );
        return;
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    String? msg;
    switch(err.error){
      case SocketException:
        msg = '인터넷이 연결되어 있지 않습니다.';
      case HttpException:
        msg = '서버 주소 설정이 잘못 되었습니다.';
      case FormatException:
        msg = '데이터 형태가 잘못 되었습니다.';
      default:
        msg = '잘못된 접근입니다.\n다시 시도해주세요.';
    }

    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text('오류발생!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red)),
          content:  Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.warning_amber_outlined,
                  size: 60,
                  color: Colors.black),
              const SizedBox(
                height: 24,
              ),
              Text(msg ?? '',
                textAlign: TextAlign.center,),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    handler.resolve(err.response ??
        Response(
            requestOptions: err.requestOptions,
            statusCode: err.response?.statusCode));
  }
}
