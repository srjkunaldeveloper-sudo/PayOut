import 'package:flutter/material.dart';

class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0; // Standard Card
  static const double xxl = 28.0; // Hero Card / Bottom Sheet
  static const double hero = 32.0;
  static const double circle = 999.0; // Pill button / Avatar

  // BorderRadius presets
  static const BorderRadius borderXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius borderCircle = BorderRadius.all(Radius.circular(circle));
}

// Backwards compatibility wrapper for AppRadii
class AppRadii {
  static const double cardHero = AppRadius.xxl;
  static const double card = AppRadius.xl;
  static const double cardSmall = AppRadius.md;
  static const double button = AppRadius.circle;
  static const double bottomSheet = AppRadius.xxl;
}
