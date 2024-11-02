import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color
  static const primary = Color(0xFF3D568F);
  static var primary500 = Color(0xff3D568F).withOpacity(0.1);

  // Background colors
  static const background = Color(0xFFFDFDF5);

  // Grayscale colors
  static const gray = Color(0xff71727A);
  static const gray500 = Color(0xffDADADA);
  static const white = Color(0xffFFFFFF);
  static const black = Color(0xff000000);

  // Status colors
  static const info = Color(0xff006FFD);
  static const warning = Color(0xffE8BE32);
  static const danger = Color(0xffED3241);
  static const success = Color(0xff3AC0A0);

  // Additional status colors
  static const danger500 = Color(0xFFFFE9E9);
  static const secondary = Color(0xffEAF3B2);

  // Dark mode colors
  static const primaryDark = Color(0xFF001442); 
  static var primary500Dark = const Color(0xFF001442).withOpacity(0.8); 

  // Background and grayscale for dark mode
  static const backgroundDark = Color(0xFF1E1E1E);
  static const grayDark = Color(0xffB0B3B8); 
  static const whiteDark = Color(0xffE5E5E5); 
  static const blackDark = Color(0xff000000); 

  // Neutral grayscale for dark mode
  static const gray500Dark = Color(0xff4A4A4A); 

  // Status colors adjusted for dark mode
  static const infoDark = Color(0xff3383FF); 
  static const warningDark = Color(0xffD69E2E); 
  static const dangerDark = Color(0xffE75A5B); 
  static const successDark = Color(0xff27A38E); 

  // Additional status colors for dark mode
  static const danger500Dark = Color(0xFF592929); 
  static const secondaryDark = Color(0xff6E8754); 
}
