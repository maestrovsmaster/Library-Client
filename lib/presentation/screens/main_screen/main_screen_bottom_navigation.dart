import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/presentation/widgets/navigation/nav_item.dart';

class MainScreenBottomNavigationBar extends StatelessWidget {
  final userIsAdmin;
  final int currentIndex;
  final ValueChanged<int> onTap;


  const MainScreenBottomNavigationBar({
    super.key,
    required this.userIsAdmin,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: 86,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              showUnselectedLabels: true,
              onTap: onTap,
              items: [
                buildNavItem(
                  context,
                  iconPath: 'assets/images/ic_home.svg',
                  label: "Home",
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
                  iconPath: 'assets/images/collections_bookmark.svg',
                  label: translate('reading_plans'),
                  isSelected: currentIndex == 2,
                ),
                buildNavItem(
                  context,
                  iconPath: 'assets/images/ic_account.svg',
                  label: translate('tab_settings'),
                  isSelected: currentIndex == 3,
                ),
                if(userIsAdmin)
                buildNavItem(
                  context,
                  iconPath: 'assets/images/ic_admin_panel.svg',
                  label:"Admin",
                  isSelected: currentIndex == 4,
                  color: AppColors.redSoft,
                ),
              ],
            )));
  }

}