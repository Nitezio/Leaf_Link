import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme get textTheme {
    return TextTheme(
      // Hero Title (32px Bold)
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      // Screen Title (24-28px Bold)
      displayMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
      // Section Title (18-20px Semibold)
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),
      // Body (14-16px Regular)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      // Label (12px Medium)
      labelLarge: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.foreground,
      ),
      // Tiny (10px Regular)
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
    );
  }

  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.destructive,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.foreground,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        shadowColor: Color(0x141B4332), // approx 0.08 alpha
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        hintStyle: TextStyle(color: AppColors.mutedForeground),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.ring),
        ),
        prefixIconColor: AppColors.mutedForeground,
      ),
      useMaterial3: true,
    );
  }
}
