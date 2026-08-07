import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double smallPhone = 360.0;
  static const double phone = 480.0;
  static const double largePhone = 600.0;
  static const double tablet = 900.0;
}

extension ResponsiveLayoutExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isSmallPhone => screenWidth <= AppBreakpoints.smallPhone;
  bool get isPhone => screenWidth > AppBreakpoints.smallPhone && screenWidth <= AppBreakpoints.phone;
  bool get isLargePhone => screenWidth > AppBreakpoints.phone && screenWidth <= AppBreakpoints.largePhone;
  bool get isTablet => screenWidth > AppBreakpoints.largePhone && screenWidth <= AppBreakpoints.tablet;
  bool get isDesktop => screenWidth > AppBreakpoints.tablet;

  bool get isMobile => screenWidth <= AppBreakpoints.largePhone;
}
