import 'package:flutter/material.dart';
import 'package:sitama/core/config/themes/app_color.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    
    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightWarning,
      surface: AppColors.lightBackground,
      surfaceContainer: AppColors.lightWhite,
      error: AppColors.lightDanger500,
      onPrimary: AppColors.lightWhite,
      onSecondary: AppColors.lightBlack,
      onSurface: AppColors.lightBlack,
      onError: AppColors.lightBlack,
      tertiary: AppColors.lightPrimary500,
      inversePrimary: AppColors.lightPrimary,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.lightWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightWhite),
      actionsIconTheme: IconThemeData(color: AppColors.lightWhite),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.lightWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.lightBlack),
      displayMedium: TextStyle(color: AppColors.lightBlack),
      displaySmall: TextStyle(color: AppColors.lightBlack),
      headlineLarge: TextStyle(color: AppColors.lightBlack),
      headlineMedium: TextStyle(color: AppColors.lightBlack),
      headlineSmall: TextStyle(color: AppColors.lightBlack),
      titleLarge: TextStyle(color: AppColors.lightBlack),
      titleMedium: TextStyle(color: AppColors.lightBlack),
      titleSmall: TextStyle(color: AppColors.lightBlack),
      bodyLarge: TextStyle(color: AppColors.lightBlack),
      bodyMedium: TextStyle(color: AppColors.lightBlack),
      bodySmall: TextStyle(color: AppColors.lightGray),
      labelLarge: TextStyle(color: AppColors.lightBlack),
      labelMedium: TextStyle(color: AppColors.lightBlack),
      labelSmall: TextStyle(color: AppColors.lightGray),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGray500),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGray500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightDanger),
      ),
      labelStyle: const TextStyle(color: AppColors.lightGray),
      hintStyle: const TextStyle(color: AppColors.lightGray),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.lightGray,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.lightWhite,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryLight,
    scaffoldBackgroundColor: AppColors.darkBackground,
    
    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimaryLight,
      secondary: AppColors.darkWarning,
      surface: AppColors.darkBackground,
      surfaceContainer: AppColors.darkWhite, 
      error: AppColors.darkDanger500,
      onPrimary: AppColors.lightWhite, 
      onSecondary: AppColors.lightWhite,
      onSurface: AppColors.lightWhite,
      onError: AppColors.lightWhite,
      tertiary: AppColors.darkPrimary500,
      inversePrimary: AppColors.darkPrimaryDark,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.lightWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightWhite),
      actionsIconTheme: IconThemeData(color: AppColors.lightWhite),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.darkWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.lightWhite),
      displayMedium: TextStyle(color: AppColors.lightWhite),
      displaySmall: TextStyle(color: AppColors.lightWhite),
      headlineLarge: TextStyle(color: AppColors.lightWhite),
      headlineMedium: TextStyle(color: AppColors.lightWhite),
      headlineSmall: TextStyle(color: AppColors.lightWhite),
      titleLarge: TextStyle(color: AppColors.lightWhite),
      titleMedium: TextStyle(color: AppColors.lightWhite),
      titleSmall: TextStyle(color: AppColors.lightWhite),
      bodyLarge: TextStyle(color: AppColors.lightWhite),
      bodyMedium: TextStyle(color: AppColors.lightWhite),
      bodySmall: TextStyle(color: AppColors.darkGray),
      labelLarge: TextStyle(color: AppColors.lightWhite),
      labelMedium: TextStyle(color: AppColors.lightWhite),
      labelSmall: TextStyle(color: AppColors.darkGray),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkPrimaryLight),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.darkDanger),
      ),
      labelStyle: const TextStyle(color: AppColors.darkGray),
      hintStyle: const TextStyle(color: AppColors.darkGray),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.darkGray,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimaryLight,
      foregroundColor: AppColors.lightWhite,
    ),
  );
}