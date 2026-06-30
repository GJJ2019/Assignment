import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.surface,
      dividerColor: AppColors.border,
      primaryColor: AppColors.primary,
      hintColor: AppColors.textMuted,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
        outline: AppColors.border,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      primaryColor: AppColors.primary,
      hintColor: const Color(0xFF94A3B8),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        background: const Color(0xFFF8FAFC),
        surface: Colors.white,
        error: AppColors.error,
        outline: const Color(0xFFE2E8F0),
        onSurface: const Color(0xFF0F172A),
        onBackground: const Color(0xFF0F172A),
      ),
    );
  }
}
