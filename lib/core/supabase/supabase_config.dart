import '../config/env_config.dart';

/// Supabase project credentials & environment configuration.
/// Loaded from `.env` first, with fallback to `--dart-define` values.
class SupabaseConfig {
  SupabaseConfig._();

  static const String _defineUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const String _defineAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  static String get url => EnvConfig.get('SUPABASE_URL', fallback: _defineUrl);

  static String get anonKey =>
      EnvConfig.get('SUPABASE_ANON_KEY', fallback: _defineAnonKey);

  static bool get isConfigured =>
      url != 'https://your-project.supabase.co' &&
      anonKey != 'your-anon-key' &&
      url.isNotEmpty &&
      anonKey.isNotEmpty;
}

