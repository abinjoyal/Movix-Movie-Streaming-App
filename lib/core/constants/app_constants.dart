/// Global application constants for Movix.
class AppConstants {
  AppConstants._();

  static const String appName = 'Movix';
  static const String appTagline = 'Stream Your Favorite Movies & Shows';

  // Network timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int initialPage = 1;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
}

