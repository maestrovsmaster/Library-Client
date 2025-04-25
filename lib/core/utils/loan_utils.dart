import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class LoanStatus {
  final String text;
  final Color color;

  LoanStatus({required this.text, required this.color});
}

LoanStatus getLoanStatus(DateTime? dateBorrowed) {
  if (dateBorrowed == null) {
    return LoanStatus(text: '', color: Colors.black54);
  }

  final now = DateTime.now();
  final borrowed = DateTime(dateBorrowed.year, dateBorrowed.month, dateBorrowed.day);
  final dueDate = borrowed.add(const Duration(days: 14));
  final difference = dueDate.difference(now).inDays;

  if (difference > 0) {
    return LoanStatus(
      text: 'Лишилося $difference ${pluralizeDays(difference)}',
      color: AppColors.badgeColorGreen,
    );
  } else if (difference == 0) {
    return LoanStatus(
      text: 'Сьогодні час повернути книгу',
      color: AppColors.accentColor,
    );
  } else {
    return LoanStatus(
      text: 'Термін повернення прострочено на ${-difference} ${pluralizeDays(-difference)}',
      color: AppColors.redSoft,
    );
  }
}

String pluralizeDays(int days) {
  final lastDigit = days % 10;
  final lastTwoDigits = days % 100;

  if (lastTwoDigits >= 11 && lastTwoDigits <= 14) {
    return 'днів';
  }
  if (lastDigit == 1) {
    return 'день';
  }
  if (lastDigit >= 2 && lastDigit <= 4) {
    return 'дні';
  }
  return 'днів';
}