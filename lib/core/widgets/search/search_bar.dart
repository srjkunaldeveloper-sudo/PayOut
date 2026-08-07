import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search bills, merchants, contacts...',
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool showMic = controller == null || controller!.text.isEmpty;

    return Container(
      height: 54.0,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.circle)),
        boxShadow: AppShadow.small,
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20.0,
            ),
            suffixIcon: !showMic
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppColors.textSecondary,
                      size: 18.0,
                    ),
                    onPressed: () {
                      controller!.clear();
                      if (onChanged != null) onChanged!('');
                    },
                  )
                : const Icon(
                    Icons.mic_rounded,
                    color: AppColors.textSecondary,
                    size: 20.0,
                  ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s16,
            ),
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ),
      ),
    );
  }
}
