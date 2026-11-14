import 'package:flutter/services.dart';
import '../utils/logger.dart';

/// Loads environment configuration from the bundled `.env` file at startup,
/// with graceful fallback to compile-time `--dart-define` defaults.
class EnvConfig {
  EnvConfig._();

  static final Map<String, String> _values = {};
  static bool _isLoaded = false;

  static bool get isLoaded => _isLoaded;

  /// Parses `.env` asset lines into memory. Safe if `.env` is absent.
  static Future<void> load({String assetPath = '.env'}) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      _values.clear();

      for (final rawLine in raw.split('\n')) {
        final line = rawLine.trim();
        if (line.isEmpty || line.startsWith('#')) continue;

        final equalsIndex = line.indexOf('=');
        if (equalsIndex <= 0) continue;

        final key = line.substring(0, equalsIndex).trim();
        var value = line.substring(equalsIndex + 1).trim();

        // Strip matching surrounding quotes if present.
        if (value.length >= 2 &&
            ((value.startsWith('"') && value.endsWith('"')) ||
                (value.startsWith("'") && value.endsWith("'")))) {
          value = value.substring(1, value.length - 1);
        }

        if (key.isNotEmpty) {
          _values[key] = value;
        }
      }

      _isLoaded = true;
      AppLogger.i('.env configuration loaded (${_values.length} keys).');
    } catch (e) {
      AppLogger.w('No .env asset loaded; falling back to defaults: $e');
    }
  }

  /// Returns non-empty value from `.env` or [fallback].
  static String get(String key, {String fallback = ''}) {
    final envValue = _values[key];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim();
    }
    return fallback;
  }
}

