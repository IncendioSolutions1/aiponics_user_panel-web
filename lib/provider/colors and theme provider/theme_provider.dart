import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aiponics_web_app/theme/theme.dart';

// Define the StateNotifier for theme management
class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightMode); // Initialize with darkMode

  // Method to toggle between light and dark modes
  void toggleTheme() {
    state = (state == lightMode) ? darkMode : lightMode;
  }

  // Getter to check if the theme is dark mode
  bool get isDarkMode => state == darkMode;
}

// Define the provider for the ThemeNotifier
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
