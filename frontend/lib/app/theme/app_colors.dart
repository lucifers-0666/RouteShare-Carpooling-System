import 'package:flutter/material.dart';

/// Centralized color tokens for the Sahyān design system.
/// Standardized color palette strictly enforcing the approved Stitch/Figma design guidelines.
abstract class AppColors {
  /// Brand Primary - Forest Green (primary actions, selected states, active nav)
  static const Color primaryForest = Color(0xFF285A4A);

  /// Brand Secondary - Deep Forest (headers, dark surfaces, main titles)
  static const Color deepForest = Color(0xFF193D33);

  /// Informational / Secondary Accent - Muted Sage
  static const Color mutedSage = Color(0xFF71877B);

  /// Subtle Surface Tint / Highlight - Soft Forest
  static const Color softForest = Color(0xFFDDE9E3);

  /// Verification & Rating Highlight - Muted Brass
  static const Color mutedBrass = Color(0xFFB99558);

  /// Rating Container Tint - Soft Brass
  static const Color softBrass = Color(0xFFEFE4CD);

  /// Primary Canvas Surface - Warm Background
  static const Color warmBackground = Color(0xFFF6F7F4);

  /// Card / Surface Pure White
  static const Color white = Color(0xFFFFFFFF);

  /// Dividers and Input Borders
  static const Color border = Color(0xFFE2E7E3);

  /// Text Primary - Dominant dark text
  static const Color textPrimary = Color(0xFF18211D);

  /// Text Secondary - Muted subtitles, timestamps, captions
  static const Color textSecondary = Color(0xFF68736C);

  /// Error / Alert / Cancellation - Muted Rust
  static const Color mutedRust = Color(0xFFA65B4B);

  /// Success State Tint
  static const Color success = Color(0xFF285A4A);

  /// Transparent
  static const Color transparent = Colors.transparent;
}
