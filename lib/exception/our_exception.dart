import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class OurException {
  int code;
  String error;

  OurException(this.code, this.error);

  static String kNoInternet = "Проверьте ваше\nинтернет-соединение";
  static String kTimeoutError = "Таймаут";
  static String kTokenExpired = "Токен устарел";
  static String kJsonError = "Ошибка разбора JSON";
  static String kUnknownError = "Неизвестная ошибка";
  static String kServerError = "Ошибка интернета"; // "Ошибка сервера"; // 500
  static String kWrongAnswer = "Ошибка ответа сервера";
  static int kHttpTimeout = 40;

  static Map<int, String> httpCodeText = {
    401: 'Неверный логин/пароль',
    404: 'Страница не найдена',
    405: 'Метод не определен',
  };

  @override
  String toString() => "$code: $error";

  // String fatalErrorText(Exception e) {
  //   return (e is SocketException)
  //       ? OurException.kNoInternet
  //   // : (e is JsonUnsupportedObjectError)
  //   //   ? OurException.kNoInternet
  //       : (e is TimeoutException)
  //       ? OurException.kServerError
  //       : OurException.kUnknownError;
  // }

  factory OurException.fromBody(int statusCode, String body) {
    final re = OurException(
      statusCode,
      body,
    );
    return re;
  }

  factory OurException.fromResponse(Response response) {
    try {
      return OurException.fromBody(
          response.statusCode, utf8.decode(response.bodyBytes));
    } catch (_) {
      if (kDebugMode) {
        print('OurException.fromResponse: ${response.statusCode}');
      }
      return OurException(
          response.statusCode,
          httpCodeText.containsKey(response.statusCode)
              ? httpCodeText[response.statusCode]!
              : kUnknownError);
    }
  }
}
