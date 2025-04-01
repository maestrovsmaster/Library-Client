import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

import 'custom_menu_popup.dart';




class PopupBottleMenuWidget extends StatelessWidget {
  final String title;
  final Function(String) onSelected;
  final bool isExpanded;
  final List<String> items;

  const PopupBottleMenuWidget({
    super.key,
    required this.title,
    required this.onSelected,
    required this.isExpanded,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: PopupMenuButton<String>(
          onSelected: onSelected,
          itemBuilder: (BuildContext context) => List.generate(
            3,
                (index) => CustomPopupMenuItem(
              text: items[index],
              value: "item${index + 1}",
                  onSelected: (value){
                    onSelected(value);
                    GoRouter.of(context).pop();

                  },
            ),
          ),
          child: SizedBox(
            height: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.backgroundBottleDetails,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Image.asset(
                          'assets/images/img_genuine.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 8),
                       Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.accentColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}