import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class RememberMeCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool initialValue;

  const RememberMeCheckbox({
    super.key,
    required this.onChanged,
    this.initialValue = false,
  });

  @override
  RememberMeCheckboxState createState() => RememberMeCheckboxState();
}

class RememberMeCheckboxState extends State<RememberMeCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          activeColor: AppColors.accentColor,
          checkColor: AppColors.secondaryText,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
            widget.onChanged(_isChecked);
          },
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
            widget.onChanged(_isChecked);
          },
          child: Text(
            "Remember me",
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: _isChecked ? AppColors.accentColor : AppColors
                  .secondaryText,
            ),
          ),
        ),
      ],
    );
  }

}