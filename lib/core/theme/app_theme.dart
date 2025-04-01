import 'package:flutter/material.dart';
import 'app_colors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.background,
        secondary: AppColors.accentColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accentColor,
        selectionColor: AppColors.accentColor.withOpacity(0.1),
        selectionHandleColor: AppColors.accentColor,
      ),
      cardColor: AppColors.cardBackground,
      cardTheme: const CardTheme(
        color: AppColors.cardBackground,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.literata(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        headlineMedium: GoogleFonts.literata(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
        titleLarge: GoogleFonts.literata(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        bodyLarge: GoogleFonts.literata(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryText,
        ),
        bodyMedium: GoogleFonts.literata(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
        labelLarge: GoogleFonts.literata(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: GoogleFonts.literata(
          color: AppColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.literata(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.tabActive,
        unselectedItemColor: AppColors.tabInactive,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.literata(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.tabActive,
        ),
        unselectedLabelStyle: GoogleFonts.literata(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.tabInactive,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.secondaryText),
        floatingLabelStyle: TextStyle(
          color: AppColors.accentColor,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryText),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentColor,
      ),
    );
  }
}
