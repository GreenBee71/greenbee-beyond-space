import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Colors - Premium Deep Navy & Gold Palette
  static const Color cyberYellow = Color(0xFFFFD700); // Bright Gold/Yellow
  static const Color accentMint = cyberYellow; 
  static const Color primaryGold = cyberYellow;
  static const Color neonGreen = cyberYellow;
  static const Color primaryGreen = cyberYellow;
  
  static const Color navyDark = Color(0xFF020C1B); // Deepest Navy
  static const Color navyMedium = Color(0xFF0A192F); // Surface Navy
  static const Color navyLight = Color(0xFF112240); // Border/Element Navy
  static const Color deepSpace = navyDark; 
  static const Color voidBlack = navyMedium;
  static const Color alertRed = Color(0xFFFF5252);
  static const Color glassBorder = Color(0x3364FFDA); // Teal-ish tint for neon feel
  static const Color textHigh = Colors.white;
  static const Color textMedium = Color(0xCCD1D1E0); // Cloud Grey
  static const Color textLow = Color(0x88D1D1E0); 

  // Text Style Base
  static TextStyle get _baseStyle => TextStyle(
    fontFamily: 'Paperlogy',
    color: textHigh,
    letterSpacing: 0.2,
  );

  // Text Theme (Paperlogy, max weight 500, standardized sizes)
  static TextTheme get textTheme => TextTheme(
    displayLarge: _baseStyle.copyWith(fontSize: 34, fontWeight: FontWeight.w500, letterSpacing: -0.5),
    displayMedium: _baseStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w500, letterSpacing: -0.5),
    displaySmall: _baseStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
    headlineMedium: _baseStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
    titleLarge: _baseStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
    titleMedium: _baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    titleSmall: _baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: textMedium),
    bodyLarge: _baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    bodyMedium: _baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: textMedium),
    labelLarge: _baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: accentMint),
    bodySmall: _baseStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: textLow),
  );

  // Minimalist Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSpace,
      primaryColor: accentMint,
      fontFamily: 'Paperlogy',
      colorScheme: const ColorScheme.dark(
        primary: accentMint,
        secondary: accentMint,
        surface: voidBlack,
        error: alertRed,
        onSurface: textHigh,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // More professional left-aligned look often used in minimalist UI
        titleTextStyle: const TextStyle(
          fontFamily: 'Paperlogy',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textHigh,
          letterSpacing: -0.2,
        ),
        iconTheme: const IconThemeData(color: textHigh, size: 22),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white12, // Subtle dark but clickable
          foregroundColor: textHigh,
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'Paperlogy',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: glassBorder, width: 0.5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: glassBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: glassBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentMint, width: 0.5),
        ),
        labelStyle: const TextStyle(color: textLow, fontSize: 20, fontFamily: 'Paperlogy'),
        floatingLabelStyle: const TextStyle(color: accentMint, fontSize: 20, fontFamily: 'Paperlogy'),
      ),
    );
  }

  static InputDecoration glassInputDecoration({String? label, String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.03),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: glassBorder, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: glassBorder, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentMint, width: 0.5),
      ),
      labelStyle: const TextStyle(color: textLow, fontSize: 20, fontFamily: 'Paperlogy'),
      floatingLabelStyle: const TextStyle(color: accentMint, fontSize: 20, fontFamily: 'Paperlogy'),
    );
  }

  static TextStyle get headingLarge => textTheme.displaySmall!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
}
