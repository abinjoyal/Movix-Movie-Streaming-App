/// Centralized asset path constants for the Movix application.
class AppAssets {
  AppAssets._();

  // Root directories
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _animations = 'assets/animations';
  static const String _posters = 'assets/posters';
  static const String _fonts = 'assets/fonts';

  // Logo & Branding
  static const String logoDir = '$_images/logo';
  static const String logo = '$_images/logo/logo.png';
  static const String appLogo = '$_images/logo/app_logo.png';
  static const String movixLogo = '$_images/logo/movix_logo.svg';

  // Onboarding
  static const String onboardingDir = '$_images/onboarding';
  static const String onboarding1 = '$_images/onboarding/onboarding_1.png';

  // Illustrations
  static const String illustrationsDir = '$_images/illustrations';

  // Placeholders
  static const String placeholdersDir = '$_images/placeholders';
  static const String posterPlaceholder = '$_images/placeholders/poster_placeholder.png';
  static const String avatarPlaceholder = '$_images/placeholders/avatar_placeholder.jpg';

  // Local Profile Avatars
  static const String avatarsDir = '$_images/avatars';
  static const String avatar1 = '$avatarsDir/avatar_1.jpg';
  static const String avatar2 = '$avatarsDir/avatar_2.jpg';
  static const String avatar3 = '$avatarsDir/avatar_3.jpg';
  static const String avatar4 = '$avatarsDir/avatar_4.jpg';
  static const String avatar5 = '$avatarsDir/avatar_5.jpg';

  static const List<String> avatarPresets = [
    avatarPlaceholder,
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
  ];

  /// Returns a valid local asset path for profile avatars, replacing any
  /// empty or legacy remote network URLs with [avatarPlaceholder].
  static String resolveProfileAvatar(String? path) {
    final trimmed = path?.trim() ?? '';
    if (trimmed.isEmpty ||
        trimmed.startsWith('http://') ||
        trimmed.startsWith('https://')) {
      return avatarPlaceholder;
    }
    return trimmed;
  }

  // Icons & Fonts
  static const String iconsDir = _icons;
  static const String fontsDir = _fonts;
  static const String icFacebook = '$_icons/facebook.png';
  static const String icGoogle = '$_icons/google.png';
  static const String icApple = '$_icons/apple.png';

  // Lottie Animations
  static const String animationsDir = _animations;
  static const String loadingAnimation = '$_animations/loading.json';
  static const String emptyAnimation = '$_animations/empty.json';

  // Local Sample Posters
  static const String postersDir = _posters;
}

