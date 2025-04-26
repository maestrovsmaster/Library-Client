import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/presentation/widgets/navigation/nav_item.dart';

class AdminBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: SizedBox(
            height: 86,
            child: Container(color: AppColors.yellow,
                child:
            BottomNavigationBar(
              currentIndex: currentIndex,
              showUnselectedLabels: true,
              onTap: onTap,
              items: [
                buildNavItem(
                  context,
                  iconPath: 'assets/images/ic_scan.svg',
                  label: translate('tab_scan'),
                  isSelected: currentIndex == 0,
                ),
                buildNavItem(
                  context,
                  iconPath: 'assets/images/ic_menu_book.svg',
                  label: translate('tab_collection'),
                  isSelected: currentIndex == 1,
                ),
                buildNavItem(
                  context,
                  iconPath: 'assets/images/ic_book.svg',
                  label: translate('tab_reservations'),
                  isSelected: currentIndex == 2,
                ),


              ],
            ))));
  }
}

