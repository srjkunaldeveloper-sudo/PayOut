import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Geist Sans',
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: AppColors.textPrimary,
        ),
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      centerTitle: false,
      leading: showLeading && Navigator.of(context).canPop()
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded, // M3 Round Arrow
                color: AppColors.textPrimary,
              ),
              onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: AppSpacing.s16),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
