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
        selectionColor: AppColors.accentColor.withValues(alpha: 0.1),
        selectionHandleColor: AppColors.accentColor,
      ),
      cardColor: AppColors.cardBackground,
      cardTheme: const CardTheme(
        color: AppColors.cardBackground,
      ),
      textTheme: TextTheme(
        //For Title
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
        //For Card Item title
        titleLarge: GoogleFonts.literata(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),

        //For item details keys
        bodyLarge: GoogleFonts.literata(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryText,
        ),
        //For Card Item subtitle
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
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: AppColors.background,
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.tabActive,
        unselectedItemColor: AppColors.tabInactive,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.literata(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.accentColor,
        ),
        unselectedLabelStyle: GoogleFonts.literata(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.tabInactive,
        ),

      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.blue, // Колір індикатора по всій апці
      ),
    );
  }
}
