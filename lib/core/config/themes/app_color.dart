import 'dart:ui';

class AppColors {
  // Light Theme Colors
  static const lightPrimary = Color(0xFF3D568F);
  static var lightPrimary500 = Color(0xff3D568F).withOpacity(0.1);
  static const lightBackground = Color(0xFFFDFDF5);
  static const lightGray = Color(0xff71727A);
  static const lightGray500 = Color(0xffDADADA);
  static const lightWhite = Color(0xffFFFFFF);
  static const lightBlack = Color(0xff000000);
  static const lightInfo = Color(0xff006FFD);
  static const lightWarning = Color(0xffE8BE32);
  static const lightDanger = Color(0xffED3241);
  static const lightSuccess = Color(0xff3AC0A0);
  static const lightDanger500 = Color(0xFFFFE9E9);
  static const lightSecondary = Color(0xffEAF3B2);

  // Dark Theme Colors
  // Versi lebih terang untuk primary
  static const darkPrimaryLight = Color(0xFF5B7AC7);  
  static const darkPrimaryDark = Color(0xFF001442);   
  static var darkPrimary500 = Color(0xFF5B7AC7).withOpacity(0.2);
  
  static const darkBackground = Color(0xFF121212);    
  static const darkGray = Color(0xFFB3B4BB);         
  static const darkGray500 = Color(0xFF404040);      
  static const darkWhite = Color(0xFF2C2C2C);       
  static const darkBlack = Color(0xFFE1E1E1);        
  
  // Status colors untuk dark theme - dibuat lebih terang dan saturated
  static const darkInfo = Color(0xFF4B9FFF);        
  static const darkWarning = Color(0xFFFAD352);     
  static const darkDanger = Color(0xFFFF4D5B);      
  static const darkSuccess = Color(0xFF4DE4BE);     
  static const darkDanger500 = Color(0xFF331A1A);   
  static const darkSecondary = Color(0xFF4A4D3A);   

  // Method untuk mendapatkan warna berdasarkan theme
  static Color getPrimaryColor(bool isDarkMode, {bool isLighter = true}) {
    if (isDarkMode) {
      return isLighter ? darkPrimaryLight : darkPrimaryDark;
    }
    return lightPrimary;
  }

  // Method untuk mendapatkan background color
  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? darkBackground : lightBackground;
  }

  // Method untuk mendapatkan text color
  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? darkBlack : lightBlack;
  }
}