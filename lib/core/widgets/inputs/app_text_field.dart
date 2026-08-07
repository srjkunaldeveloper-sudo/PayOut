import 'package:flutter/material.dart';
import 'package:payout/core/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isObscure;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final String? helperText;
  final bool isDisabled;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const AppTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
    this.prefix,
    this.suffix,
    this.errorText,
    this.helperText,
    this.isDisabled = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure,
      enabled: !isDisabled,
      onChanged: onChanged,
      validator: validator,
      style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        errorText: errorText,
        helperText: helperText,
      ),
    );
  }
}
