import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';


class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    
    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.warning.withOpacity(0.2),
      background: AppColors.background,
      surface: AppColors.white,
      error: AppColors.danger500,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onBackground: AppColors.black,
      onSurface: AppColors.black,
      onError: AppColors.black,
      surfaceVariant: AppColors.primary500,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      actionsIconTheme: IconThemeData(color: AppColors.white),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.black),
      displayMedium: TextStyle(color: AppColors.black),
      displaySmall: TextStyle(color: AppColors.black),
      headlineLarge: TextStyle(color: AppColors.black),
      headlineMedium: TextStyle(color: AppColors.black),
      headlineSmall: TextStyle(color: AppColors.black),
      titleLarge: TextStyle(color: AppColors.black),
      titleMedium: TextStyle(color: AppColors.black),
      titleSmall: TextStyle(color: AppColors.black),
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.black),
      bodySmall: TextStyle(color: AppColors.gray),
      labelLarge: TextStyle(color: AppColors.black),
      labelMedium: TextStyle(color: AppColors.black),
      labelSmall: TextStyle(color: AppColors.gray),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.gray500),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.gray500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      labelStyle: const TextStyle(color: AppColors.gray),
      hintStyle: const TextStyle(color: AppColors.gray),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.gray,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.warningDark.withOpacity(0.2),
      background: AppColors.backgroundDark,
      surface: AppColors.gray500Dark,
      error: AppColors.danger500Dark,
      onPrimary: AppColors.whiteDark,
      onSecondary: AppColors.whiteDark,
      onBackground: AppColors.whiteDark,
      onSurface: AppColors.whiteDark,
      onError: AppColors.whiteDark,
      surfaceVariant: AppColors.primary500Dark,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.whiteDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.whiteDark),
      actionsIconTheme: IconThemeData(color: AppColors.whiteDark),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.gray500Dark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.whiteDark),
      displayMedium: TextStyle(color: AppColors.whiteDark),
      displaySmall: TextStyle(color: AppColors.whiteDark),
      headlineLarge: TextStyle(color: AppColors.whiteDark),
      headlineMedium: TextStyle(color: AppColors.whiteDark),
      headlineSmall: TextStyle(color: AppColors.whiteDark),
      titleLarge: TextStyle(color: AppColors.whiteDark),
      titleMedium: TextStyle(color: AppColors.whiteDark),
      titleSmall: TextStyle(color: AppColors.whiteDark),
      bodyLarge: TextStyle(color: AppColors.whiteDark),
      bodyMedium: TextStyle(color: AppColors.whiteDark),
      bodySmall: TextStyle(color: AppColors.grayDark),
      labelLarge: TextStyle(color: AppColors.whiteDark),
      labelMedium: TextStyle(color: AppColors.whiteDark),
      labelSmall: TextStyle(color: AppColors.grayDark),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray500Dark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grayDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grayDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryDark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.dangerDark),
      ),
      labelStyle: const TextStyle(color: AppColors.grayDark),
      hintStyle: const TextStyle(color: AppColors.grayDark),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.grayDark,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.whiteDark,
    ),
  );
}