import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class CustomPopupMenuItem extends PopupMenuEntry<String> {
  final String text;
  final String value;
  final Function(String) onSelected;

  const CustomPopupMenuItem({
    super.key,
    required this.text,
    required this.value,
    required this.onSelected,
  });

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(String? value) => this.value == value;

  @override
  State<CustomPopupMenuItem> createState() => _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onSelected(widget.text);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
