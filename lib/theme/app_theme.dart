import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'app_colors.dart';


/// Gaya teks: Playfair Display untuk judul, Inter untuk isi.
class AppText {
  AppText._();


  static TextStyle display(
    double size, {
    FontStyle? style,
    Color color = AppColors.textPrimary,
  }) => GoogleFonts.playfairDisplay(
    fontSize: size,
    fontWeight: FontWeight.w600,
    fontStyle: style,
    color: color,
  );


  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
  }) => GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);


  static TextStyle get eyebrow => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.6,
    color: AppColors.gold,
  );
}


class AppTheme {
  AppTheme._();


  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: AppColors.bgBase,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.bgBase,
        secondary: AppColors.goldLight,
        surface: AppColors.bgSurface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: AppColors.bgSurface),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
