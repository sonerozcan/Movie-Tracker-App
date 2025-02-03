import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors
  static const primaryColor = Color(0xFF6B4EFF);
  static const accentColor = Color(0xFFFF4E8C);
  static const backgroundColor = Color(0xFFF8F9FE);

  // Dark theme colors
  static const darkPrimaryColor = Color(0xFF9D86FF);  // Lighter purple for dark mode
  static const darkAccentColor = Color(0xFFFF6FA3);   // Lighter pink for dark mode
  static const darkBackgroundColor = Color(0xFF000000);  // Pure black
  static const darkCardColor = Color(0xFF141414);     // Very dark gray
  static const darkSurfaceColor = Color(0xFF0A0A0A);  // Almost black
  static const darkTextColor = Color(0xFFFFFFFF);     // White text
  static const darkTextSecondaryColor = Color(0xFFB3B3B3);  // Light gray text

  static ThemeData get lightTheme {
    return _buildTheme(brightness: Brightness.light);
  }

  static ThemeData get darkTheme {
    return _buildTheme(brightness: Brightness.dark);
  }

  static ThemeData _buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    
    return ThemeData(
      brightness: brightness,
      primaryColor: isDark ? darkPrimaryColor : primaryColor,
      scaffoldBackgroundColor: isDark ? darkBackgroundColor : backgroundColor,
      dialogBackgroundColor: isDark ? darkCardColor : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? darkBackgroundColor : primaryColor,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDark ? darkCardColor : Colors.white,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: isDark ? darkCardColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? darkCardColor : Colors.white,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? darkCardColor : Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? darkAccentColor : accentColor,
        elevation: isDark ? 0 : 8,
        extendedPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? darkPrimaryColor : primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkCardColor : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: (isDark ? darkPrimaryColor : primaryColor).withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: (isDark ? darkPrimaryColor : primaryColor).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? darkPrimaryColor : primaryColor,
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
} 