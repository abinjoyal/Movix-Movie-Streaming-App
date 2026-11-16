import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

/// Centralized typography styles for the Movix application.
class AppTypography {
  AppTypography._();

  static const String? primaryFontFamily = null; // Uses system or custom font in assets/fonts

  // Base text styles
  static const TextStyle _displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle _displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle _displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle _headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle _headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle _headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle _titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle _titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle _titleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle _bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle _bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static const TextStyle _bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.5,
  );

  static const TextStyle _labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    height: 1.4,
  );

  static const TextStyle _labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    height: 1.4,
  );

  static const TextStyle _labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.4,
  );

  // Dark text theme
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: _displayLarge.copyWith(color: AppColors.darkTextPrimary),
    displayMedium: _displayMedium.copyWith(color: AppColors.darkTextPrimary),
    displaySmall: _displaySmall.copyWith(color: AppColors.darkTextPrimary),
    headlineLarge: _headlineLarge.copyWith(color: AppColors.darkTextPrimary),
    headlineMedium: _headlineMedium.copyWith(color: AppColors.darkTextPrimary),
    headlineSmall: _headlineSmall.copyWith(color: AppColors.darkTextPrimary),
    titleLarge: _titleLarge.copyWith(color: AppColors.darkTextPrimary),
    titleMedium: _titleMedium.copyWith(color: AppColors.darkTextPrimary),
    titleSmall: _titleSmall.copyWith(color: AppColors.darkTextSecondary),
    bodyLarge: _bodyLarge.copyWith(color: AppColors.darkTextPrimary),
    bodyMedium: _bodyMedium.copyWith(color: AppColors.darkTextSecondary),
    bodySmall: _bodySmall.copyWith(color: AppColors.darkTextMuted),
    labelLarge: _labelLarge.copyWith(color: AppColors.darkTextPrimary),
    labelMedium: _labelMedium.copyWith(color: AppColors.darkTextSecondary),
    labelSmall: _labelSmall.copyWith(color: AppColors.darkTextMuted),
  );

  // Light text theme
  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: _displayLarge.copyWith(color: AppColors.lightTextPrimary),
    displayMedium: _displayMedium.copyWith(color: AppColors.lightTextPrimary),
    displaySmall: _displaySmall.copyWith(color: AppColors.lightTextPrimary),
    headlineLarge: _headlineLarge.copyWith(color: AppColors.lightTextPrimary),
    headlineMedium: _headlineMedium.copyWith(color: AppColors.lightTextPrimary),
    headlineSmall: _headlineSmall.copyWith(color: AppColors.lightTextPrimary),
    titleLarge: _titleLarge.copyWith(color: AppColors.lightTextPrimary),
    titleMedium: _titleMedium.copyWith(color: AppColors.lightTextPrimary),
    titleSmall: _titleSmall.copyWith(color: AppColors.lightTextSecondary),
    bodyLarge: _bodyLarge.copyWith(color: AppColors.lightTextPrimary),
    bodyMedium: _bodyMedium.copyWith(color: AppColors.lightTextSecondary),
    bodySmall: _bodySmall.copyWith(color: AppColors.lightTextMuted),
    labelLarge: _labelLarge.copyWith(color: AppColors.lightTextPrimary),
    labelMedium: _labelMedium.copyWith(color: AppColors.lightTextSecondary),
    labelSmall: _labelSmall.copyWith(color: AppColors.lightTextMuted),
  );
}

