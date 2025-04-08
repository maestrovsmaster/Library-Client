import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating; // 0.0 .. 5.0
  final double size;

  const RatingWidget({
    Key? key,
    required this.rating,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(_buildSvgStar('assets/images/star_full.svg' , ColorFilter.mode(AppColors.yellow, BlendMode.srcIn)));
    }

    if (hasHalfStar) {
      stars.add(_buildSvgStar('assets/images/star_half.svg', ColorFilter.mode(Colors.amber, BlendMode.srcIn)));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(_buildSvgStar('assets/images/star_empty.svg',ColorFilter.mode(Colors.grey, BlendMode.srcIn)));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  Widget _buildSvgStar(String assetPath,ColorFilter  colorFilter ) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter:  colorFilter ,
    );
  }
}
