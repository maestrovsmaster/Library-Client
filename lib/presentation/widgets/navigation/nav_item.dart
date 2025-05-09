import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

BottomNavigationBarItem buildNavItem(
    BuildContext context, {
      String? iconPath,
      IconData? icon,
      required String label,
      required bool isSelected,
      Color? color,
    }) {
  return BottomNavigationBarItem(
    backgroundColor: AppColors.tabBackground,

    icon: iconPath != null
        ? SvgPicture.asset(
      iconPath,
      height: 24,
      width: 24,
      colorFilter: ColorFilter.mode(
        color ?? (
        isSelected
            ? Theme.of(context)
            .bottomNavigationBarTheme
            .selectedItemColor!
            : Colors.grey),
        BlendMode.srcIn,
      ),
    )
        : Icon(
      icon,
      color: color ?? (isSelected
          ? AppColors.tabActive
          : Colors.grey),
    ),
    label: translate(label),
  );
}
