import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:payout/core/config/app_config.dart';
import 'package:payout/features/auth/services/session_manager.dart';
import 'package:payout/features/auth/presentation/login_screen.dart';
import 'package:payout/features/dashboard/presentation/dashboard_shell.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _shineController;
  
  // Coordinated animations using _introController (0 to 2000ms duration)
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoGlowScale;
  late Animation<double> _logoGlowOpacity;
  
  late Animation<double> _orbitOpacity;
  late Animation<double> _orbitScale;
  
  late Animation<double> _particleProgress;
  late Animation<double> _particleOpacity;
  
  late Animation<double> _titleOpacity;
  late Animation<double> _titleSlide;
  
  late Animation<double> _subtitleOpacity;
  late Animation<double> _subtitleSlide;
  
  late Animation<double> _accentLineOpacity;
  late Animation<double> _accentLineScale;
  
  late Animation<double> _shinePosition;

  // Tiny cyan/purple particles surrounding the logo
  final List<Particle> _particles = const [
    Particle(angle: 35, baseDistance: 95, color: Color(0xFF00B9F1), size: 5.5),
    Particle(angle: 155, baseDistance: 105, color: Color(0xFF002E6E), size: 6.0),
    Particle(angle: 235, baseDistance: 90, color: Color(0xFF00B9F1), size: 4.5),
    Particle(angle: 305, baseDistance: 115, color: Color(0xFF002E6E), size: 5.0),
    Particle(angle: 80, baseDistance: 100, color: Color(0xFF00B9F1), size: 3.5),
    Particle(angle: 195, baseDistance: 120, color: Color(0x7F002E6E), size: 4.0),
  ];

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Initialize all coordinated entry animations
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.325, curve: Curves.easeOutCubic),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.325, curve: Curves.easeOutCubic),
      ),
    );
    _logoGlowOpacity = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.325, curve: Curves.easeOutCubic),
      ),
    );
    _logoGlowScale = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.325, curve: Curves.easeOutCubic),
      ),
    );

    _orbitOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.175, 0.5, curve: Curves.easeOut),
      ),
    );
    _orbitScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.175, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _particleProgress = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _particleOpacity = Tween<double>(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.5, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _accentLineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );
    _accentLineScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Looping shine animation config
    _shinePosition = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _shineController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Start intro and loops
    _introController.forward();
    _shineController.repeat();

    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    final startTime = DateTime.now();

    // Attempt automatic session retrieval
    await SessionManager.instance.autoLogin();

    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final remaining = 2400 - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }

    if (!mounted) return;

    final bool isLoggedIn = SessionManager.instance.isLoggedIn && AppConfig.isDemoMode;
    final Widget targetScreen = isLoggedIn ? const DashboardShell() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = FadeTransition(
            opacity: animation,
            child: child,
          );
          final scale = ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: fade,
          );
          return scale;
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Wavy Background
          const Positioned.fill(
            child: CustomPaint(
              painter: SplashBackgroundPainter(),
            ),
          ),
          
          // 2. Main Content Area (SafeArea to prevent device overflows)
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top spacer
                const Spacer(flex: 3),
                
                // Centered Logo & Orbit Group
                SizedBox(
                  width: 320,
                  height: 320,
                  child: AnimatedBuilder(
                    animation: _introController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Concentric Orbit Circles
                          Opacity(
                            opacity: _orbitOpacity.value,
                            child: CustomPaint(
                              size: const Size(320, 320),
                              painter: OrbitPainter(scale: _orbitScale.value),
                            ),
                          ),
                          
                          // Soft glow behind logo
                          Opacity(
                            opacity: _logoGlowOpacity.value,
                            child: Transform.scale(
                              scale: _logoGlowScale.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Color(0x3500B9F1),
                                      Color(0x10002E6E),
                                      Colors.transparent,
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Cyan/Purple particles surrounding logo
                          ..._particles.map((p) {
                            final double progress = _particleProgress.value;
                            final double rad = p.angle * math.pi / 180;
                            final double dist = p.baseDistance * progress;
                            final double dx = math.cos(rad) * dist;
                            final double dy = math.sin(rad) * dist;

                            return Transform.translate(
                              offset: Offset(dx, dy),
                              child: Opacity(
                                opacity: _particleOpacity.value,
                                child: Container(
                                  width: p.size,
                                  height: p.size,
                                  decoration: BoxDecoration(
                                    color: p.color,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: p.color.withOpacity(0.4),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          
                          // Logo Image Widget
                          Opacity(
                            opacity: _logoOpacity.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: Container(
                                width: 95,
                                height: 95,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF002E6E).withOpacity(0.08),
                                      blurRadius: 20,
                                      spreadRadius: 4,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF00B9F1).withOpacity(0.04),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Image.asset(
                                    'assets/logo/splash_logo.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Typography Section
                AnimatedBuilder(
                  animation: _introController,
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // "SRJ UPI" Text Reveal
                        Transform.translate(
                          offset: Offset(0, _titleSlide.value),
                          child: Opacity(
                            opacity: _titleOpacity.value,
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Geist Sans',
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'SRJ ',
                                    style: TextStyle(color: Color(0xFF1B1464)),
                                  ),
                                  TextSpan(
                                    text: 'UPI',
                                    style: TextStyle(color: Color(0xFF00B9F1)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // "Payout" Text Reveal
                        Transform.translate(
                          offset: Offset(0, _subtitleSlide.value),
                          child: Opacity(
                            opacity: _subtitleOpacity.value,
                            child: Text(
                              'Payout',
                              style: TextStyle(
                                fontFamily: 'Geist Sans',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1F1F1F).withOpacity(0.7),
                                letterSpacing: 4.5,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Gradient Accent Line / Shine
                        Opacity(
                          opacity: _accentLineOpacity.value,
                          child: Transform.scale(
                            scale: _accentLineScale.value,
                            child: AnimatedBuilder(
                              animation: _shinePosition,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: const Size(100, 2.5),
                                  painter: AccentLinePainter(
                                    shinePosition: _shinePosition.value,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  final double angle;
  final double baseDistance;
  final Color color;
  final double size;

  const Particle({
    required this.angle,
    required this.baseDistance,
    required this.color,
    required this.size,
  });
}

class SplashBackgroundPainter extends CustomPainter {
  const SplashBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw linear gradient background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF9FAFF),
          Color(0xFFECEFFC),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Draw Bottom Waves
    final double h = size.height;
    final double w = size.width;

    // Wave 1 (Back wave, subtle purple/blue)
    final path1 = Path();
    path1.moveTo(0, h * 0.82);
    path1.quadraticBezierTo(w * 0.25, h * 0.78, w * 0.55, h * 0.83);
    path1.quadraticBezierTo(w * 0.8, h * 0.87, w, h * 0.8);
    path1.lineTo(w, h);
    path1.lineTo(0, h);
    path1.close();

    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x35E3EAFE),
          Color(0x55CAD3F5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, h * 0.75, w, h * 0.25));
    canvas.drawPath(path1, paint1);

    // Wave 2 (Middle wave, deeper opacity with dot grid)
    final path2 = Path();
    path2.moveTo(0, h * 0.86);
    path2.quadraticBezierTo(w * 0.35, h * 0.82, w * 0.7, h * 0.88);
    path2.quadraticBezierTo(w * 0.88, h * 0.9, w, h * 0.85);
    path2.lineTo(w, h);
    path2.lineTo(0, h);
    path2.close();

    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x60DFE5FD),
          Color(0x80C2CCF4),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, h * 0.8, w, h * 0.2));
    canvas.drawPath(path2, paint2);

    // Draw dot patterns on top/clipped to Wave 2
    canvas.save();
    canvas.clipPath(path2);
    final dotPaint = Paint()..color = const Color(0x33A6B4E5);
    for (double x = 0; x < w * 0.45; x += 12) {
      for (double y = h * 0.83; y < h; y += 12) {
        canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
      }
    }
    canvas.restore();

    // Wave 3 (Front wave, solid soft background color with gradient)
    final path3 = Path();
    path3.moveTo(0, h * 0.9);
    path3.quadraticBezierTo(w * 0.3, h * 0.87, w * 0.6, h * 0.92);
    path3.quadraticBezierTo(w * 0.8, h * 0.94, w, h * 0.89);
    path3.lineTo(w, h);
    path3.lineTo(0, h);
    path3.close();

    final paint3 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xAAECEFF8),
          Color(0xFFEBF0FA),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, h * 0.85, w, h * 0.15));
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OrbitPainter extends CustomPainter {
  final double scale;
  const OrbitPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double baseRadius = 85.0 * scale;

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Orbit 1: Radius 85
    orbitPaint.color = const Color(0x1500B9F1);
    canvas.drawCircle(center, baseRadius, orbitPaint);

    // Orbit 2: Radius 125
    orbitPaint.color = const Color(0x10002E6E);
    canvas.drawCircle(center, baseRadius + 40 * scale, orbitPaint);

    // Orbit 3: Radius 165
    orbitPaint.color = const Color(0x0600B9F1);
    canvas.drawCircle(center, baseRadius + 80 * scale, orbitPaint);

    final nodePaint = Paint()..style = PaintingStyle.fill;

    // Node 1: On Orbit 1 at 45 degrees
    nodePaint.color = const Color(0x7F00B9F1);
    final double rad1 = 45 * math.pi / 180;
    canvas.drawCircle(
      center + Offset(math.cos(rad1) * baseRadius, math.sin(rad1) * baseRadius),
      3.5 * scale,
      nodePaint,
    );

    // Node 2: On Orbit 2 at 210 degrees
    nodePaint.color = const Color(0x66002E6E);
    final double rad2 = 210 * math.pi / 180;
    final double radius2 = baseRadius + 40 * scale;
    canvas.drawCircle(
      center + Offset(math.cos(rad2) * radius2, math.sin(rad2) * radius2),
      4.0 * scale,
      nodePaint,
    );

    // Node 3: On Orbit 3 at 135 degrees
    nodePaint.color = const Color(0x4400B9F1);
    final double rad3 = 135 * math.pi / 180;
    final double radius3 = baseRadius + 80 * scale;
    canvas.drawCircle(
      center + Offset(math.cos(rad3) * radius3, math.sin(rad3) * radius3),
      2.5 * scale,
      nodePaint,
    );
    
    // Node 4: On Orbit 3 at 320 degrees
    nodePaint.color = const Color(0x33002E6E);
    final double rad4 = 320 * math.pi / 180;
    canvas.drawCircle(
      center + Offset(math.cos(rad4) * radius3, math.sin(rad4) * radius3),
      3.0 * scale,
      nodePaint,
    );
  }

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}

class AccentLinePainter extends CustomPainter {
  final double shinePosition;

  const AccentLinePainter({required this.shinePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final double h = size.height;
    final double w = size.width;

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF00B9F1),
          Color(0xFF1B1464),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(h / 2),
    );
    canvas.drawRRect(rrect, linePaint);

    final shinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.9),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(w * (shinePosition - 0.2), 0, w * 0.4, h))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(rrect, shinePaint);
    canvas.restore();

    final dotPaint = Paint()..style = PaintingStyle.fill;
    
    // Left dot (cyan)
    dotPaint.color = const Color(0xFF00B9F1);
    canvas.drawCircle(Offset(-6, h / 2), 1.5, dotPaint);

    // Right dot (purple)
    dotPaint.color = const Color(0xFF1B1464);
    canvas.drawCircle(Offset(w + 6, h / 2), 1.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant AccentLinePainter oldDelegate) {
    return oldDelegate.shinePosition != shinePosition;
  }
}
