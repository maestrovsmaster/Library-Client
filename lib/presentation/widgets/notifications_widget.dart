import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsWidget extends StatelessWidget {
  final bool hasNotifications;
  final VoidCallback onClick;

  const NotificationsWidget({
    super.key,
    required this.hasNotifications,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'assets/images/ic_bell.svg',
                  height: 24,
                  width: 24,
                ),
                if (hasNotifications)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: SvgPicture.asset(
                      'assets/images/ic_badge.svg',
                      height: 8,
                      width: 8,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
