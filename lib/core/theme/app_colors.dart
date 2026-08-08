import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  // Brand Palette
  static const Color primary = Color(0xFF0B57D0); // Google Blue
  static const Color primaryContainer = Color(0xFFE8F0FE); // Google Soft blue containers
  static const Color primaryLight = primaryContainer; // Backwards compatibility alias
  static const Color secondary = Color(0xFF5F6368); // Google Secondary Slate
  static const Color accent = Color(0xFF1A73E8); // Google Accent Blue

  // Neutral Greys
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFF1F3F4);
  static const Color grey200 = Color(0xFFE8EAED);
  static const Color grey300 = Color(0xFFDADCE0);
  static const Color grey400 = Color(0xFFBDC1C6);
  static const Color grey500 = Color(0xFF9AA0A6);
  static const Color grey600 = Color(0xFF7F868A);
  static const Color grey700 = Color(0xFF5F6368);
  static const Color grey800 = Color(0xFF3C4043);
  static const Color grey900 = Color(0xFF202124);

  // Surfaces & Boundaries
  static const Color background = Color(0xFFF0F4F9); // Distinct Soft Gray-Blue background
  static const Color surface = Color(0xFFFFFFFF); // Pure White Cards
  static const Color surfaceVariant = Color(0xFFE8EAED);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFDADCE0);
  static const Color border = Color(0xFFDADCE0);

  // Text Elements
  static const Color textPrimary = Color(0xFF1F1F1F); // Google Dark Charcoal
  static const Color textSecondary = Color(0xFF5F6368); // Google secondary gray
  static const Color textHint = Color(0xFF9AA0A6);
  static const Color textDisabled = Color(0xFFDADCE0);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Semantic Feedback
  static const Color success = Color(0xFF137333); // Google Green
  static const Color warning = Color(0xFFB06000); // Google Amber
  static const Color error = Color(0xFFC5221F); // Google Red
  static const Color info = Color(0xFF1A73E8); // Google Info Blue

  // Finance Ledger Specifics
  static const Color income = Color(0xFF137333);
  static const Color expense = Color(0xFFC5221F);
  static const Color credit = Color(0xFF137333);
  static const Color debit = Color(0xFFC5221F);
  static const Color pending = Color(0xFFB06000);
  static const Color failed = Color(0xFFC5221F);
}
