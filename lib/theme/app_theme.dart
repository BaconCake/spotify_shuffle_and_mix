import 'package:flutter/material.dart';

class AppTheme {
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color spotifyBlack = Color(0xFF191414);
  static const Color spotifyDarkGray = Color(0xFF282828);
  static const Color spotifyLightGray = Color(0xFFB3B3B3);
  static const Color spotifyWhite = Color(0xFFFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: spotifyBlack,
      colorScheme: const ColorScheme.dark(
        primary: spotifyGreen,
        secondary: spotifyGreen,
        surface: spotifyDarkGray,
        onPrimary: spotifyBlack,
        onSecondary: spotifyBlack,
        onSurface: spotifyWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: spotifyBlack,
        foregroundColor: spotifyWhite,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: spotifyGreen,
          foregroundColor: spotifyBlack,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: spotifyWhite,
          side: const BorderSide(color: spotifyLightGray),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: spotifyDarkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: spotifyGreen, width: 2),
        ),
        hintStyle: const TextStyle(color: spotifyLightGray),
      ),
      cardTheme: CardThemeData(
        color: spotifyDarkGray,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}