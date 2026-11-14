import '../config/env_config.dart';

/// Configuration settings for The Movie Database (TMDB) API.
class TmdbConfig {
  TmdbConfig._();

  static const String _defineApiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'your_tmdb_api_key_here',
  );

  static const String _defineAccessToken = String.fromEnvironment(
    'TMDB_ACCESS_TOKEN',
    defaultValue: '',
  );

  /// API Key loaded from `.env` (`TMDB_API_KEY`) or `--dart-define`.
  static String get apiKey =>
      EnvConfig.get('TMDB_API_KEY', fallback: _defineApiKey);

  /// TMDB Read Access Token (Bearer Token) from `.env` or `--dart-define`.
  static String get readAccessToken =>
      EnvConfig.get('TMDB_ACCESS_TOKEN', fallback: _defineAccessToken);

  static bool get isConfigured {
    final key = apiKey.trim();
    return key.isNotEmpty &&
        !key.startsWith('your_') &&
        !key.startsWith('http://') &&
        !key.startsWith('https://');
  }

  static const String defaultLanguage = 'en-US';
  static const String defaultRegion = 'US';
}
