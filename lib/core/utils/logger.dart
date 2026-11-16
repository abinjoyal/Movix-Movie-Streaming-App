import 'package:flutter/foundation.dart';

/// Lightweight logging utility for development and debugging.
class AppLogger {
  AppLogger._();

  static void d(String message) {
    if (kDebugMode) {
      debugPrint('[DEBUG] [Movix] $message');
    }
  }

  static void i(String message) {
    if (kDebugMode) {
      debugPrint('[INFO]  [Movix] $message');
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      debugPrint('[WARN]  [Movix] ⚠️ $message');
    }
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[ERROR] [Movix] ❌ $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace:\n$stackTrace');
    }
  }
}

