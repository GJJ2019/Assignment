import 'package:flutter/material.dart';

class AppColors {
  // Brand color palette (Alive Green)
  static const Color primary = Color(0xFF7CD902);
  static const Color primaryLight = Color(0xFF9BED05);
  static const Color primaryDark = Color(0xFF5CA200);

  // Background and surface colors (Rich premium dark mode)
  static const Color background = Color(0xFF0C101B);
  static const Color surface = Color(0xFF161C2C);
  static const Color surfaceLight = Color(0xFF222B43);
  static const Color border = Color(0xFF2E3A5A);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Other colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x05FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
