import '../exception/our_exception.dart';
import '../models/PasswordVerificationData.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/exception/extension_exception.dart';

class MwProvider{
  http.Response? response;

  Uri mwUri(String method) {
    return Uri(
        scheme: 'http',
        host: '192.168.0.101',
        path: '/DemoHRM/hs/references/$method',
        port: 80);
  }

  Future<PasswordVerificationData> getPasswordData() async {
    try {
      if (kDebugMode) await Future.delayed(const Duration(seconds: 1));
      final Uri uri = mwUri('getConst');
      response = await http.get(uri,
          headers: {'Authorization': 'Basic 0K7RiNC60L7QkNCQOjExMTE='}).timeout(
        Duration(seconds: OurException.kHttpTimeout),
        onTimeout: () => throw TimeoutException(null),
      );
    } on Exception catch (e) {
      throw OurException(500, e.fatalErrorText());
    } catch (o) {
      throw OurException(-1, o.toString());
    }

    try {
      if (response!.statusCode == 200) {
        final Map<String, dynamic> map =
        json.decode(utf8.decode(response!.bodyBytes));
        return PasswordVerificationData.fromJson(map);
      } else {
        throw OurException.fromResponse(response!);
      }
    } catch (e) {
      throw (e is OurException) ? e : OurException(-1, e.toString());
    }
  }
}