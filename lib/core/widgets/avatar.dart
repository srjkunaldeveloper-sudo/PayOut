import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class CustomAvatar extends StatelessWidget {
  final String name;
  final double size;
  final String? imageUrl;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomAvatar({
    super.key,
    required this.name,
    this.size = 48.0,
    this.imageUrl,
    this.backgroundColor,
    this.textColor,
  });

  String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: 1.0),
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: size * 0.35,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
    );
  }
}
