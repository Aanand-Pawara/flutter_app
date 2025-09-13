import 'package:flutter/foundation.dart';

class Debug {
  static void log(String message, {String tag = "DEBUG"}) {
    debugPrint("[$tag] $message");
  }

  static void warn(String message, {String tag = "WARNING"}) {
    debugPrint("[$tag] ⚠️ $message");
  }

  static void error(String message, {String tag = "ERROR"}) {
    debugPrint("[$tag] ❌ $message");
  }
}
