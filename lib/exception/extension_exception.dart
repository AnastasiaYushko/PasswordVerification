import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'our_exception.dart';

extension FatalText on Exception {
  String fatalErrorText() {
    return (this is SocketException)
        ? OurException.kNoInternet
        : (this is JsonUnsupportedObjectError)
            ? OurException.kJsonError
            : (this is TimeoutException)
                ? OurException.kServerError
                : (this is FormatException)
                    ? OurException.kJsonError
                    : OurException.kUnknownError;
    // : this.toString();
  }
}
