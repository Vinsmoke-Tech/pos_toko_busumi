import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

void objectPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

void jsonPrint(Object? jsonObject) {
  if (kDebugMode) {
    final prettyString = const JsonEncoder.withIndent('  ').convert(jsonObject);
    log(prettyString);
  }
}

void jsonStringPrint(String? jsonObject) {
  if (kDebugMode) {
    final object = json.decode(jsonObject!);
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    log(prettyString);
  }
}