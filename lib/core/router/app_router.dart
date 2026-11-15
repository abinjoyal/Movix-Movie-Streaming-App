import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/otp_verification_screen.dart';
import '../../features/authentication/presentation/screens/reset_password_screen.dart';
import '../../features/authentication/presentation/screens/reset_success_screen.dart';
import '../../features/authentication/presentation/screens/signup_screen.dart';
import '../../features/downloads/presentation/screens/download_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/watchlist/presentation/screens/watchlist_screen.dart';
import '../../features/home/presentation/screens/see_all_movies_screen.dart';
import '../../features/movie_details/presentation/screens/cast_movies_screen.dart';
import '../../features/movie_details/presentation/screens/movie_comments_screen.dart';
import '../../features/movie_details/presentation/screens/movie_details_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/about_us_screen.dart';
import '../../features/profile/presentation/screens/download_settings_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/help_center_screen.dart';
import '../../features/profile/presentation/screens/language_screen.dart';
import '../../features/profile/presentation/screens/notification_settings_screen.dart';
import '../../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/security_settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/subscription/presentation/screens/add_card_screen.dart';
import '../../features/subscription/presentation/screens/payment_method_screen.dart';
import '../../features/subscription/presentation/screens/payment_selection_screen.dart';
import '../../features/subscription/presentation/screens/review_summary_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/subscription/presentation/screens/subscription_success_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';

/// Navigation key for top-level navigation access.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Provider that creates and manages the [GoRouter] instance.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.initial,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RoutePaths.initial,
        name: RouteNames.initial,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          final email = state.extra as String?;
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        name: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.resetSuccess,
        name: RouteNames.resetSuccess,
        builder: (context, state) => const ResetSuccessScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.explore,
        name: RouteNames.explore,
        builder: (context, state) => const ExploreScreen(),
      ),
      GoRoute(
        path: RoutePaths.watchlist,
        name: RouteNames.watchlist,
        builder: (context, state) => const WatchlistScreen(),
      ),
      GoRoute(
        path: RoutePaths.download,
        name: RouteNames.download,
        builder: (context, state) => const DownloadScreen(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.notificationSettings,
        name: RouteNames.notificationSettings,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.downloadSettings,
        name: RouteNames.downloadSettings,
        builder: (context, state) => const DownloadSettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.securitySettings,
        name: RouteNames.securitySettings,
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.languageSettings,
        name: RouteNames.languageSettings,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: RoutePaths.privacyPolicy,
        name: RouteNames.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RoutePaths.helpCenter,
        name: RouteNames.helpCenter,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: RoutePaths.aboutUs,
        name: RouteNames.aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: RoutePaths.subscription,
        name: RouteNames.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: RoutePaths.paymentMethod,
        name: RouteNames.paymentMethod,
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: RoutePaths.addCard,
        name: RouteNames.addCard,
        builder: (context, state) => const AddCardScreen(),
      ),
      GoRoute(
        path: RoutePaths.paymentSelection,
        name: RouteNames.paymentSelection,
        builder: (context, state) => const PaymentSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.reviewSummary,
        name: RouteNames.reviewSummary,
        builder: (context, state) => const ReviewSummaryScreen(),
      ),
      GoRoute(
        path: RoutePaths.subscriptionSuccess,
        name: RouteNames.subscriptionSuccess,
        builder: (context, state) => const SubscriptionSuccessScreen(),
      ),
      GoRoute(
        path: RoutePaths.top10Movies,
        name: RouteNames.top10Movies,
        builder: (context, state) =>
            const SeeAllMoviesScreen(type: SeeAllType.top10),
      ),
      GoRoute(
        path: RoutePaths.newReleases,
        name: RouteNames.newReleases,
        builder: (context, state) =>
            const SeeAllMoviesScreen(type: SeeAllType.newReleases),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: RoutePaths.movieDetails,
        name: RouteNames.movieDetails,
        builder: (context, state) {
          final rawId = state.pathParameters['id'] ?? '0';
          final movieId = int.tryParse(rawId) ?? 0;
          return MovieDetailsScreen(movieId: movieId);
        },
      ),
      GoRoute(
        path: RoutePaths.tvDetails,
        name: RouteNames.tvDetails,
        builder: (context, state) {
          final rawId = state.pathParameters['id'] ?? '0';
          final showId = int.tryParse(rawId) ?? 0;
          return MovieDetailsScreen(movieId: showId, isTvShow: true);
        },
      ),
      GoRoute(
        path: RoutePaths.movieComments,
        name: RouteNames.movieComments,
        builder: (context, state) {
          final rawId = state.pathParameters['id'] ?? '0';
          final movieId = int.tryParse(rawId) ?? 0;
          final isTvShow = state.uri.queryParameters['tv'] == '1';
          return MovieCommentsScreen(movieId: movieId, isTvShow: isTvShow);
        },
      ),
      GoRoute(
        path: RoutePaths.castMovies,
        name: RouteNames.castMovies,
        builder: (context, state) {
          final rawId = state.pathParameters['id'] ?? '0';
          final personId = int.tryParse(rawId) ?? 0;
          final personName =
              state.uri.queryParameters['name'] ?? 'Cast & Crew';
          final isTvMaze = state.uri.queryParameters['tv'] == '1';
          return CastMoviesScreen(
            personId: personId,
            personName: personName,
            isTvMaze: isTvMaze,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Route not found: ${state.uri}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
  );
});
