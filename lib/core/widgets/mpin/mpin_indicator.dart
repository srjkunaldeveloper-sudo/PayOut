import 'package:flutter/material.dart';

class PremiumMpinIndicator extends StatelessWidget {
  final int pinLength;
  final int maxLength;
  final bool isLoading;

  const PremiumMpinIndicator({
    super.key,
    required this.pinLength,
    required this.maxLength,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          strokeWidth: 2.5,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < pinLength;
        final isActive = index == pinLength;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isFilled
                ? const LinearGradient(
                    colors: [
                      Color(0xFF3F37C9),
                      Color(0xFF4895EF),
                    ],
                  )
                : null,
            color: isFilled ? null : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? Colors.transparent
                  : (isActive ? const Color(0xFF4895EF) : const Color(0xFFCBD5E1)),
              width: 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF4895EF).withValues(alpha: 0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }
}
