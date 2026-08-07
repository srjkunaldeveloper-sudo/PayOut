import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF2563EB); // Payout Blue
  static const Color primaryContainer = Color(0xFFEFF6FF); // Soft blue containers
  static const Color primaryLight = primaryContainer; // Backwards compatibility alias
  static const Color secondary = Color(0xFF475569); // Slate secondary
  static const Color accent = Color(0xFF3B82F6); // Light blue accent

  // Neutral Greys
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // Surfaces & Boundaries
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFE2E8F0);

  // Text Elements
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Semantic Feedback
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Rose Red
  static const Color info = Color(0xFF3B82F6); // Sky Blue

  // Finance Ledger Specifics
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color credit = Color(0xFF10B981);
  static const Color debit = Color(0xFFEF4444);
  static const Color pending = Color(0xFFF59E0B);
  static const Color failed = Color(0xFFEF4444);
}
