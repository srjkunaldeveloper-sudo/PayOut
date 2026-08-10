import 'package:flutter/material.dart';

class MPINBackgroundPainter extends CustomPainter {
  const MPINBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFBFBFF),
          Color(0xFFF3F6FD),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Extremely subtle radial gradient glow highlights (cyan & purple)
    final Paint glowPaint = Paint()..style = PaintingStyle.fill;
    
    // Cyan glow (top right)
    glowPaint.shader = RadialGradient(
      colors: [
        const Color(0xFF00B9F1).withValues(alpha: 0.04),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.9, size.height * 0.1), radius: 250));
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), 250, glowPaint);

    // Purple glow (middle left)
    glowPaint.shader = RadialGradient(
      colors: [
        const Color(0xFF1B1464).withValues(alpha: 0.03),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.1, size.height * 0.5), radius: 300));
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5), 300, glowPaint);

    // 3. Floating circular accents
    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Accent Circle 1: top left
    accentPaint.color = const Color(0xFF00B9F1).withValues(alpha: 0.06);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.25), 30, accentPaint);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25), 
      3, 
      Paint()..color = const Color(0xFF00B9F1).withValues(alpha: 0.06),
    );

    // Accent Circle 2: bottom right
    accentPaint.color = const Color(0xFF1B1464).withValues(alpha: 0.04);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.75), 50, accentPaint);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.68), 
      5.5, 
      Paint()..color = const Color(0xFF00B9F1).withValues(alpha: 0.06),
    );

    // 4. Soft decorative waves near bottom rising on the right
    final double h = size.height;
    final double w = size.width;

    final path1 = Path();
    path1.moveTo(0, h * 0.88);
    path1.quadraticBezierTo(w * 0.45, h * 0.86, w * 0.75, h * 0.78);
    path1.quadraticBezierTo(w * 0.9, h * 0.75, w, h * 0.65);
    path1.lineTo(w, h);
    path1.lineTo(0, h);
    path1.close();

    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x0CCAD3F5),
          Color(0x20CAD3F5),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));
    canvas.drawPath(path1, paint1);

    // Wave 2
    final path2 = Path();
    path2.moveTo(0, h * 0.92);
    path2.quadraticBezierTo(w * 0.4, h * 0.90, w * 0.75, h * 0.83);
    path2.quadraticBezierTo(w * 0.9, h * 0.80, w, h * 0.72);
    path2.lineTo(w, h);
    path2.lineTo(0, h);
    path2.close();

    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x15DBEDFD),
          Color(0x28C2CCF4),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.7, w, h * 0.3));
    canvas.drawPath(path2, paint2);

    // Subtle dot-grid pattern clipped to bottom area
    canvas.save();
    canvas.clipPath(path2);
    final dotPaint = Paint()..color = const Color(0x12A6B4E5);
    for (double x = 0; x < w * 0.45; x += 15) {
      for (double y = h * 0.7; y < h; y += 15) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
