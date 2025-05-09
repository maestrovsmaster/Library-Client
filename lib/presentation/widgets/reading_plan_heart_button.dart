import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class ReadingPlanHeartButton extends StatefulWidget {
  final bool initiallyInPlan;
  final void Function(bool inPlan)? onChanged;

  const ReadingPlanHeartButton({
    super.key,
    this.initiallyInPlan = false,
    this.onChanged,
  });

  @override
  State<ReadingPlanHeartButton> createState() => _ReadingPlanHeartButtonState();
}

class _ReadingPlanHeartButtonState extends State<ReadingPlanHeartButton> {
  late bool inPlan;

  @override
  void initState() {
    super.initState();
    inPlan = widget.initiallyInPlan;
  }

  void toggle() {
    setState(() => inPlan = !inPlan);
    widget.onChanged?.call(inPlan);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Icon(
          inPlan ? Icons.favorite : Icons.favorite_border,
          color: AppColors.accentColor,
          size: 32,
        ),
      ),
    );
  }
}
