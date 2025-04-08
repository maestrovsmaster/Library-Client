import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class ReviewsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReviewsButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.arrow_forward_ios,
            size: 13,
            color: AppColors.secondaryText,
          ),
        ],
      ),
    );
  }
}
