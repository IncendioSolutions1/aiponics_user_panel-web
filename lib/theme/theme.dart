import 'package:aiponics_web_app/theme/table_theme.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const Color(0xFFF4F5F7), // Surface color
    primary: const Color(0xFF007AFF), // Primary color
    secondary: const Color(0xFF34C759), // Secondary color (Green for success)
    onSurface: const Color(0xFF000000), // Text color (Black)
    onSecondary: Colors.white, // Subtitle text color (Muted grey)
    surfaceContainer: Colors.greenAccent,
    onSecondaryFixed: Colors.green,
    onSecondaryContainer: Colors.white,
    secondaryFixed: Colors.grey[200],
    onPrimaryFixed: Colors.grey[300],
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Color(0xFF000000)), // Main text color for larger text
    bodyMedium: TextStyle(color: Color(0xFF000000)), // Medium text color
    bodySmall: TextStyle(color: Color(0xFF666666)), // Small text (Subtitle)
  ),
  dividerColor: const Color(0xFF333333), // Border color (Darker grey)
  extensions: <ThemeExtension<dynamic>>[
    TableColors(
      evenRowColor: const Color(0xFFF5F5F5), // Light even row
      oddRowColor: const Color(0xFFE0E0E0),  // Light odd row
      textColor: const Color(0xFF000000),    // Light row text color
    ),
  ],
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF121212), // Very dark grey background
    primary: const Color(0xFF007AFF), // Primary color
    secondary: const Color(0xFF0A84FF), // Secondary color (Blue for interaction)
    onSurface: const Color(0xFFFFFFFF), // Text color (White)
    onSecondary: const Color(0xFF1F1F1F), // Subtitle text color (Muted grey)
    surfaceContainer: const Color(0xFF006400),
    onSecondaryFixed:  const Color(0xFF006400),
    onSecondaryContainer: const Color(0xFF3A3A3A),
    secondaryFixed: Colors.grey[800],
    onPrimaryFixed:  Colors.grey[700],
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDDDDDD)),
    ),
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF)), // Main text color for larger text (White)
    bodyMedium: TextStyle(color: Color(0xFFFFFFFF)), // Medium text color (Muted grey in dark theme)
    bodySmall: TextStyle(color: Color(0xFFA6A6A6)), // Small text (Muted grey)
  ),
  dividerColor: const Color(0xFFDDDDDD), // Border color (Soft grey)
  extensions: <ThemeExtension<dynamic>>[
    TableColors(
      evenRowColor: const Color(0xFF2C2C2C), // Dark even row
      oddRowColor: const Color(0xFF1E1E1E),  // Dark odd row
      textColor: const Color(0xFFFFFFFF),    // Dark row text color
    ),
  ],
);
