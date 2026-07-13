import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_colors.dart';

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  final Color textPrimary;
  final Color textSecondary;
  final Color inputBorder;
  final Color divider;
  final Color completedBackground;
  final Color brand;
  final Color completedText;
  final Color pendingIndicator;
  final Color error;

  const AppColorsExt({
    required this.textPrimary,
    required this.textSecondary,
    required this.inputBorder,
    required this.divider,
    required this.completedBackground,
    required this.brand,
    required this.completedText,
    required this.pendingIndicator,
    required this.error,
  });

  static const light = AppColorsExt(
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    inputBorder: AppColors.inputBorderLight,
    divider: AppColors.inputBorderLight,
    completedBackground: AppColors.completedBackground,
    brand: AppColors.xpYellow,
    completedText: AppColors.completedText,
    pendingIndicator: AppColors.xpYellow,
    error: AppColors.errorRed,
  );

  static const dark = AppColorsExt(
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    inputBorder: AppColors.inputBorderDark,
    divider: AppColors.borderDark,
    completedBackground: AppColors.completedBackgroundDark,
    brand: AppColors.xpYellow,
    completedText: AppColors.completedText,
    pendingIndicator: AppColors.xpYellow,
    error: AppColors.errorRed,
  );

  @override
  AppColorsExt copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? inputBorder,
    Color? divider,
    Color? completedBackground,
    Color? brand,
    Color? completedText,
    Color? pendingIndicator,
    Color? error,
  }) {
    return AppColorsExt(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      inputBorder: inputBorder ?? this.inputBorder,
      divider: divider ?? this.divider,
      completedBackground: completedBackground ?? this.completedBackground,
      brand: brand ?? this.brand,
      completedText: completedText ?? this.completedText,
      pendingIndicator: pendingIndicator ?? this.pendingIndicator,
      error: error ?? this.error,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      completedBackground: Color.lerp(
        completedBackground,
        other.completedBackground,
        t,
      )!,
      brand: Color.lerp(brand, other.brand, t)!,
      completedText: Color.lerp(completedText, other.completedText, t)!,
      pendingIndicator: Color.lerp(
        pendingIndicator,
        other.pendingIndicator,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColorsExt get appColors => Theme.of(this).extension<AppColorsExt>()!;
}
