import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized Typography Scale for Sahyān.
/// Uses Plus Jakarta Sans as the unified primary font family throughout the app.
abstract class AppTypography {
  /// Display / Hero text for large branded headers
  static TextStyle get displayHero => GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.deepForest,
    letterSpacing: -0.02,
    height: 1.2,
  );

  /// Screen titles for top-level pages
  static TextStyle get screenTitle => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  /// Section headings within screens
  static TextStyle get sectionHeader => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Field labels above input controls
  static TextStyle get fieldLabel => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Body large for prominent descriptive paragraphs
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Body medium for standard content and descriptions
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Secondary / supporting text, subtitles, and hints
  static TextStyle get secondary => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  /// Captions, helper text, and timestamps
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  /// Buttons and primary call-to-action text
  static TextStyle get button => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.2,
  );

  /// Prominent OTP input digits
  static TextStyle get otpDigit => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.deepForest,
  );

  /// Validation feedback and error messages
  static TextStyle get validationMessage => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedRust,
    height: 1.25,
  );

  /// Badges and status pills
  static TextStyle get badge => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.deepForest,
  );
}
