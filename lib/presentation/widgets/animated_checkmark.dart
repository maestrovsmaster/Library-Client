import 'package:flutter/material.dart';

import 'package:leeds_library/core/theme/app_colors.dart';

class AnimatedCheckmark extends StatefulWidget {
  final VoidCallback onCompleted;

  const AnimatedCheckmark({super.key, required this.onCompleted});

  @override
  AnimatedCheckmarkState createState() => AnimatedCheckmarkState();
}

class AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _opacity = 1.0;

  double totalSize = 150;
  double tickSize = 100;
  int paintSpeed = 500;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: paintSpeed),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
              width: totalSize,
              height: totalSize,
              decoration: BoxDecoration(
                color: AppColors.accentColor.withAlpha(200),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            CustomPaint(
              size: Size(tickSize, tickSize),
              painter: CheckmarkPainter(_animation),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final Animation<double> animation;

  CheckmarkPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.7);
    path.lineTo(size.width * 0.8, size.height * 0.3);

    final pathMetric = path.computeMetrics().first;
    final extractPath = pathMetric.extractPath(0, pathMetric.length * animation.value);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void showCheckmark(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => AnimatedCheckmark(
      onCompleted: () {
        overlayEntry.remove();
      },
    ),
  );

  overlay.insert(overlayEntry);
}