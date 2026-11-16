import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages the active [ThemeMode] for Movix.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light); // Light theme matches the Figma reference design

  void setThemeMode(ThemeMode mode) {
    if (state != mode) {
      state = mode;
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void useSystemTheme() {
    state = ThemeMode.system;
  }
}

/// Provider exposing the current [ThemeMode].
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

