import 'package:flutter/material.dart';
import 'package:payout/core/widgets/mpin/mpin_background.paint.dart';

class MpinBackground extends StatelessWidget {
  final Widget child;

  const MpinBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: CustomPaint(
            painter: MPINBackgroundPainter(),
          ),
        ),
        child,
      ],
    );
  }
}
