import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class CreateRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final ValueChanged<double> onChanged;

  const CreateRatingBar({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      final isFull = rating >= i;
      final isHalf = rating >= (i - 0.5) && rating < i;

      stars.add(GestureDetector(
        onTap: () => onChanged(i.toDouble()),
        onHorizontalDragUpdate: (details) {
          final pos = details.localPosition.dx / size;
          final newRating = (pos.clamp(0, 5) * 1).ceil().toDouble();
          onChanged(newRating);
        },
        child: _buildSvgStar(
          isFull
              ? 'assets/images/star_full.svg'
              : isHalf
              ? 'assets/images/star_half.svg'
              : 'assets/images/star_empty.svg',
          colorFilter: ColorFilter.mode(
            isFull || isHalf ? AppColors.accentColor : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  Widget _buildSvgStar(String assetPath, {required ColorFilter colorFilter}) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: colorFilter,
    );
  }
}
