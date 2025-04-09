import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/widgets/reading_plan_heart_button.dart';
import 'package:leeds_library/presentation/widgets/reviews_button.dart';

import '../../../../core/theme/app_colors.dart';

class FooterWidget extends StatelessWidget {
  final Book book;

  const FooterWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final hasReviews = (book.reviewsCount??0) > 0;
    return  SizedBox(
      height: 64,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Divider(thickness: 1, color: AppColors.cardBackground2),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(padding: EdgeInsets.only(right: 16),child:
            ReviewsButton(text: hasReviews ? "ВІДГУКИ" : "НАПИСАТИ ВІДГУК", onPressed: (){

            }))
          ),

          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: ReadingPlanHeartButton(
                    initiallyInPlan: true,
                    onChanged: (added) {
                      // Зберегти у Firestore або видалити
                    },
                  ))),
        ],
      ),
    );
  }
}
