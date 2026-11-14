/// Storage keys for local caching, shared preferences, and secure storage.
class StorageKeys {
  StorageKeys._();

  // App settings & theme
  static const String themeMode = 'movix_theme_mode';
  static const String isOnboardingCompleted = 'movix_onboarding_completed';
  static const String languageCode = 'movix_language_code';

  // Auth & Session
  static const String supabaseSession = 'movix_supabase_session';
  static const String userProfile = 'movix_user_profile';

  // Search & history
  static const String searchHistory = 'movix_search_history';
  static const String watchlistCache = 'movix_watchlist_cache';
}

