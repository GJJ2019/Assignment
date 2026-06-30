import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive.dart';

class AppTextStyles {
  static TextStyle headingLarge({Color? color}) => GoogleFonts.outfit(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: color,
  );

  static TextStyle headingMedium({Color? color}) => GoogleFonts.outfit(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: color,
  );

  static TextStyle headingSmall({Color? color}) => GoogleFonts.outfit(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle subtitle({Color? color}) => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: color,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: color,
  );

  static TextStyle labelBold({Color? color}) => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: color,
  );

  static TextStyle buttonText({Color? color}) => GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
}
