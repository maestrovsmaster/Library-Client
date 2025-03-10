import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class CloseIconWidget extends StatelessWidget {
  final VoidCallback onClose;
  final double size;
  final double iconSize;

  const CloseIconWidget({
    super.key,
    required this.onClose,
    this.size = 48.0,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.backgroundBottleDetails,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.close,
            color: AppColors.primaryText,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
