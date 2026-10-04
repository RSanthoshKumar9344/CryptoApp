import 'package:flutter/material.dart';

abstract class AppColors {
  // Dark Theme Palette (Primary)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCardBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Common Financial Indicators & Accents
  static const Color positive = Color(0xFF10B981);
  static const Color positiveBackground = Color(0x1A10B981);
  static const Color negative = Color(0xFFEF4444);
  static const Color negativeBackground = Color(0x1AEF4444);

  static const Color primaryAccent = Color(0xFF3B82F6);
  static const Color primaryAccentLight = Color(0xFF2563EB);

  static const Color chartGradientStart = Color(0x403B82F6);
  static const Color chartGradientEnd = Color(0x003B82F6);
}
