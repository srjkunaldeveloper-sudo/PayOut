import 'package:flutter/material.dart';

class AppShadow {
  static const List<BoxShadow> none = [];

  static final List<BoxShadow> small = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.04),
      offset: const Offset(0, 2),
      blurRadius: 4.0,
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> medium = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.06),
      offset: const Offset(0, 4),
      blurRadius: 10.0,
      spreadRadius: -2.0,
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.03),
      offset: const Offset(0, 2),
      blurRadius: 4.0,
      spreadRadius: -1.0,
    ),
  ];

  static final List<BoxShadow> large = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.08),
      offset: const Offset(0, 12),
      blurRadius: 20.0,
      spreadRadius: -4.0,
    ),
  ];

  static final List<BoxShadow> floating = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.12),
      offset: const Offset(0, 16),
      blurRadius: 24.0,
      spreadRadius: -4.0,
    ),
  ];
}
