import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class AnimatedCancel extends StatefulWidget {
  final VoidCallback onCompleted;

  const AnimatedCancel({super.key, required this.onCompleted});

  @override
  AnimatedCancelState createState() => AnimatedCancelState();
}

class AnimatedCancelState extends State<AnimatedCancel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _opacity = 1.0;

  int paintSpeed = 500;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: paintSpeed),
    );


    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _opacity = 0.0;
        });
        Future.delayed(const Duration(milliseconds: 300), widget.onCompleted);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.tabInactive.withAlpha(200),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Text(
              "Item removed",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCancel(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => AnimatedCancel(
      onCompleted: () {
        overlayEntry.remove();
      },
    ),
  );

  overlay.insert(overlayEntry);
}
