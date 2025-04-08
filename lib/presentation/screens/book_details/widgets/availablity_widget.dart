import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/data/models/book.dart';

class BookAvailabilityWidget extends StatelessWidget {
  final Book book;

  const BookAvailabilityWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final isAvailable = book.isAvailable;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.cardColorGreen : AppColors.tabInactive,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Padding(padding: EdgeInsets.only(bottom: 2), child: Text(
          isAvailable ? "Доступна" : "Недоступна",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),),

        const SizedBox(width: 8),
         Icon(
          isAvailable ? Icons.check : Icons.notifications_none,
          color: Colors.white,
          size: 16,)
      ],)

    );
  }
}
