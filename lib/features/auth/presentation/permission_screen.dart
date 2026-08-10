import 'package:flutter/material.dart';
import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF002E6E).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF00B9F1).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2563EB),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Geist Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      color: const Color(0xFF1F1F1F).withOpacity(0.5),
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Subtle Premium Background
          const Positioned.fill(
            child: CustomPaint(
              painter: PermissionBackgroundPainter(),
            ),
          ),
          // 2. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Top navigation back button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF1F1F1F),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Styled Title
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Help us ',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF3F37C9),
                            Color(0xFF4895EF),
                          ],
                        ).createShader(Offset.zero & bounds.size),
                        child: const Text(
                          'secure',
                          style: TextStyle(
                            fontFamily: 'Geist Sans',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        ' your account',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    'We require the following permissions to ensure secure transactions and prevent fraud on your device.',
                    style: TextStyle(
                      fontFamily: 'Geist Sans',
                      fontSize: 14,
                      color: const Color(0xFF1F1F1F).withOpacity(0.5),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Permissions list
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildPermissionItem(
                          icon: Icons.notifications_active_rounded,
                          title: 'Notifications',
                          description: 'Get real-time transaction updates, fraud alerts, and rewards.',
                        ),
                        _buildPermissionItem(
                          icon: Icons.location_on_rounded,
                          title: 'Location',
                          description: 'Prevent fraud by verifying merchant locations and payment details.',
                        ),
                        _buildPermissionItem(
                          icon: Icons.contacts_rounded,
                          title: 'Contacts',
                          description: 'Easily send money to your friends and family from your contact list.',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Allow & Continue button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const DashboardShell()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 54,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3F37C9),
                            Color(0xFF4895EF),
                            Color(0xFF4CC9F0),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3F37C9).withOpacity(0.24),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Allow & Continue',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Skip button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const DashboardShell()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                          fontFamily: 'Geist Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F37C9),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionBackgroundPainter extends CustomPainter {
  const PermissionBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
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

    final Paint glowPaint = Paint()..style = PaintingStyle.fill;
    glowPaint.shader = RadialGradient(
      colors: [
        const Color(0xFF00B9F1).withOpacity(0.04),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.9, size.height * 0.1), radius: 250));
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), 250, glowPaint);

    glowPaint.shader = RadialGradient(
      colors: [
        const Color(0xFF1B1464).withOpacity(0.03),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: Offset(size.width * 0.1, size.height * 0.5), radius: 300));
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5), 300, glowPaint);

    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    accentPaint.color = const Color(0xFF00B9F1).withOpacity(0.06);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.25), 30, accentPaint);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25), 
      3, 
      Paint()..color = const Color(0xFF00B9F1).withOpacity(0.06),
    );

    accentPaint.color = const Color(0xFF1B1464).withOpacity(0.04);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.75), 50, accentPaint);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.68), 
      5.5, 
      Paint()..color = const Color(0xFF00B9F1).withOpacity(0.06),
    );

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
