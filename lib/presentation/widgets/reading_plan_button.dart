import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ReadingPlanButton extends StatefulWidget {
  final String bookId;
  final bool initiallyInPlan;
  final void Function(bool inPlan)? onChanged;

  const ReadingPlanButton({
    super.key,
    required this.bookId,
    this.initiallyInPlan = false,
    this.onChanged,
  });

  @override
  State<ReadingPlanButton> createState() => _ReadingPlanButtonState();
}

class _ReadingPlanButtonState extends State<ReadingPlanButton> {
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
    return TextButton.icon(
      onPressed: toggle,
      style: TextButton.styleFrom(
        backgroundColor: inPlan ? AppColors.cardColorGreen : AppColors.accentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      icon: Icon(inPlan ? Icons.check : Icons.add),
      label: Text(inPlan ? 'У планах читання' : 'Додати до плану читання'),
    );
  }
}
