import 'package:flutter/material.dart';

/// Centralized color palette for the Movix application.
/// Incorporates the signature Movix Red brand color and cinematic dark/light palettes.
class AppColors {
  AppColors._();

  // Signature Movix Brand Colors
  static const Color primaryRed = Color(0xFFE50914);
  static const Color primaryRedDark = Color(0xFFB80710);
  static const Color primaryRedLight = Color(0xFFFF333D);
  static const Color primaryRedContainer = Color(0xFF330205);

  // Dark Theme Palette (Cinematic Dark Default)
  static const Color darkBackground = Color(0xFF0D0D0F);
  static const Color darkSurface = Color(0xFF16161A);
  static const Color darkSurfaceElevated = Color(0xFF222228);
  static const Color darkCard = Color(0xFF1A1A20);
  static const Color darkBorder = Color(0xFF2A2A33);
  static const Color darkDivider = Color(0xFF1F1F27);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA0A0AB);
  static const Color darkTextMuted = Color(0xFF6B6B78);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F3F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFEAEBED);

  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);
  static const Color lightTextMuted = Color(0xFF9CA3AF);

  // Semantic & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Entertainment / Movie Specific Colors
  static const Color ratingYellow = Color(0xFFFFC107);
  static const Color shimmerBase = Color(0xFF24242C);
  static const Color shimmerHighlight = Color(0xFF363640);
  static const Color overlayGradientStart = Colors.transparent;
  static const Color overlayGradientEnd = Color(0xDE0D0D0F);
}

