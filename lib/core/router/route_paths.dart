/// Route URI path definitions for GoRouter.
class RoutePaths {
  RoutePaths._();

  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String resetSuccess = '/reset-success';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String top10Movies = '/top-10';
  static const String newReleases = '/new-releases';
  static const String notifications = '/notifications';
  static const String movieDetails = '/movie/:id';
  static const String tvDetails = '/tv/:id';
  static const String movieComments = '/movie/:id/comments';
  static const String castMovies = '/cast/:id/movies';
  static const String search = '/search';
  static const String watchlist = '/watchlist';
  static const String download = '/download';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String notificationSettings = '/profile/notifications';
  static const String downloadSettings = '/profile/downloads';
  static const String securitySettings = '/profile/security';
  static const String languageSettings = '/profile/language';
  static const String helpCenter = '/profile/help-center';
  static const String privacyPolicy = '/profile/privacy-policy';
  static const String aboutUs = '/profile/about-us';
  static const String subscription = '/subscription';
  static const String paymentMethod = '/subscription/payment-method';
  static const String addCard = '/subscription/add-card';
  static const String paymentSelection = '/subscription/select-payment';
  static const String reviewSummary = '/subscription/review';
  static const String subscriptionSuccess = '/subscription/success';

  static String movieDetailsPath(int id) => '/movie/$id';
  static String tvDetailsPath(int id) => '/tv/$id';
  static String movieCommentsPath(int id, {bool isTvShow = false}) => Uri(
        path: '/movie/$id/comments',
        queryParameters: isTvShow ? const {'tv': '1'} : null,
      ).toString();
  static String castMoviesPath(
    int personId, {
    required String name,
    bool isTvMaze = false,
  }) =>
      Uri(
        path: '/cast/$personId/movies',
        queryParameters: {
          'name': name,
          if (isTvMaze) 'tv': '1',
        },
      ).toString();
}
