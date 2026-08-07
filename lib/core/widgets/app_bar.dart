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
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      centerTitle: false,
      leading: showLeading && Navigator.of(context).canPop()
          ? Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s12, top: 4, bottom: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.divider, width: 1.0),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                ),
              ),
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
