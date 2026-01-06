import 'package:flutter/material.dart';

// App Theme System
class AppTheme {
  // Brand Colors
  static const primaryGreen = Color(0xFF4CAF50);
  static const primaryOrange = Color(0xFFFF9800);

  // Light Theme
  static final light = ThemeColors(
    background: const Color(0xFFF5F5F5),
    surfaceVariant: Colors.grey[100]!,
    textPrimary: Colors.grey[900]!,
    textSecondary: Colors.grey[600]!,
    border: Colors.grey[300]!,
    error: Colors.red[700]!,
    isDark: false,
  );

  // Dark Theme
  static final dark = ThemeColors(
    background: const Color(0xFF121212),
    surfaceVariant: Colors.grey[900]!,
    textPrimary: Colors.grey[100]!,
    textSecondary: Colors.grey[400]!,
    border: Colors.grey[800]!,
    error: Colors.red[400]!,
    isDark: true,
  );

  // Get current theme colors
  static ThemeColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  // Create Material Theme Data
  static ThemeData getLightTheme() {
    return _createThemeData(light);
  }

  static ThemeData getDarkTheme() {
    return _createThemeData(dark);
  }

  static ThemeData _createThemeData(ThemeColors colors) {
    return ThemeData(
      brightness: colors.isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: colors.isDark ? Brightness.dark : Brightness.light,
        primary: primaryGreen,
        secondary: primaryOrange,
        error: colors.error,
        surface: colors.surfaceVariant,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: colors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: colors.textPrimary),
        bodyMedium: TextStyle(color: colors.textPrimary),
        titleMedium: TextStyle(color: colors.textPrimary),
      ),
    );
  }
}

// Theme Colors Structure
class ThemeColors {
  final Color background;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color error;
  final bool isDark;

  ThemeColors({
    required this.background,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.error,
    required this.isDark,
  });
}