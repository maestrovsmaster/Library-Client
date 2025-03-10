import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool showPassword;
  final Function()? onTogglePassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.showPassword = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.accentColor),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword && !showPassword,

          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.accentColor,
              ),
              onPressed: onTogglePassword,
            )
                : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentColor, width: 2),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
