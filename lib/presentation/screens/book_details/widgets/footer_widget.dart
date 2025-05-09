import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_bloc.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_event.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/reading_plan_heart_button.dart';
import 'package:leeds_library/presentation/widgets/reviews_button.dart';

import '../../../../core/theme/app_colors.dart';

class FooterWidget extends StatelessWidget {
  final Book book;
  final bool? isBookInPlan;

  const FooterWidget({super.key, required this.book, this.isBookInPlan });

  String _pluralizeReviews(int count) {
    if (count == 0) return 'НАПИСАТИ ВІДГУК';
    if (count == 1) return '1 ВІДГУК';
    if (count >= 2 && count <= 4) return '$count ВІДГУКИ';
    return '$count ВІДГУКІВ';
  }

  @override
  Widget build(BuildContext context) {
    final reviewsCount = book.reviewsCount ?? 0;
    final text = _pluralizeReviews(reviewsCount);

    return SizedBox(
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
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ReviewsButton(
                text: text,
                onPressed: () {
                  context.push(AppRoutes.reviews, extra: book);
                },
              ),
            ),
          ),
          if(isBookInPlan != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ReadingPlanHeartButton(
                initiallyInPlan: isBookInPlan!,
                onChanged: (added) {
                  if(added){
                    print("---createeeeee");
                    context.read<BookDetailsBloc>().add(CreateReadPlanEvent(book.id));
                  }else{
                    print("---deleteeeeeee");
                    context.read<BookDetailsBloc>().add(DeleteReadPlanEvent(book.id));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
