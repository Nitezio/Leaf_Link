import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core palette — from theme.css
  static const Color background = Color(0xFFF8F4E3);
  static const Color foreground = Color(0xFF1B4332);
  static const Color card = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF1B4332);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF52B788);
  static const Color secondaryForeground = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFD8E4DD);
  static const Color mutedForeground = Color(0xFF2D6A4F);
  static const Color destructive = Color(0xFFE76F51);
  static const Color border = Color(0x1A1B4332); // rgba(27,67,50,0.1)

  // Chart greens
  static const Color chart1 = Color(0xFF52B788);
  static const Color chart2 = Color(0xFF74C69D);
  static const Color chart3 = Color(0xFF95D5B2);
  static const Color chart4 = Color(0xFFB7E4C7);
  static const Color chart5 = Color(0xFFD8F3DC);

  // Gamification gold
  static const Color gold = Color(0xFFFFD700);
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        surface: AppColors.card,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.destructive,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.foreground,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(color: AppColors.foreground),
        bodyMedium: GoogleFonts.inter(color: AppColors.foreground),
        bodySmall: GoogleFonts.inter(color: AppColors.mutedForeground),
        titleLarge: GoogleFonts.inter(
          color: AppColors.foreground,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.foreground,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(color: AppColors.mutedForeground),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
    return base;
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF121212),
        primary: Color(0xFF9BE7B5),
        secondary: Color(0xFF66C69A),
        error: Color(0xFFEF9A9A),
        onPrimary: Color(0xFF052013),
        onSecondary: Color(0xFF052013),
        onSurface: Color(0xFFE6F6EE),
        outline: Color(0x334D6654),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1720),
      cardColor: const Color(0xFF111827),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(color: Color(0xFFE6F6EE)),
        bodyMedium: GoogleFonts.inter(color: Color(0xFFE6F6EE)),
        bodySmall: GoogleFonts.inter(color: Color(0xFF9BBFAF)),
        titleLarge: GoogleFonts.inter(
          color: Color(0xFFE6F6EE),
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.inter(
          color: Color(0xFFE6F6EE),
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(color: Color(0xFF9BBFAF)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0x334D6654)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0x334D6654)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF66C69A), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9BE7B5),
          foregroundColor: const Color(0xFF052013),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
    return base;
  }
}
