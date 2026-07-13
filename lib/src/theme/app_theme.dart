import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textPrimaryLight),
        bodySmall: TextStyle(color: AppColors.textSecondaryLight),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.xpYellow,
        surface: AppColors.surfaceLight,
        error: AppColors.errorRed,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.xpYellow,
        foregroundColor: AppColors.textPrimaryLight,
        shape: StadiumBorder(),
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: _inputDecoration(AppColors.inputBorderLight),
      elevatedButtonTheme: _elevatedButtonTheme(
        AppColors.xpYellow,
        AppColors.textPrimaryLight,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      extensions: const [AppColorsExt.light],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.xpYellow,
        surface: AppColors.surfaceDark,
        error: AppColors.errorRed,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.xpYellow,
        foregroundColor: AppColors.textPrimaryLight,
        shape: StadiumBorder(),
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: _inputDecoration(AppColors.inputBorderDark),
      elevatedButtonTheme: _elevatedButtonTheme(
        AppColors.xpYellow,
        AppColors.textPrimaryLight,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      extensions: const [AppColorsExt.dark],
    );
  }

  static InputDecorationTheme _inputDecoration(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.xpYellow, width: 2),
      ),
      floatingLabelStyle: const TextStyle(color: AppColors.xpYellow),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        elevation: 0,
      ),
    );
  }
}
