// review_item.dart
import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/core/utils/utils.dart';
import 'package:leeds_library/data/models/review.dart';
import 'package:leeds_library/presentation/widgets/expandable_text.dart';
import 'package:leeds_library/presentation/widgets/rating_widget.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  final bool isMyReview;

  final Function(Review)? onEdit;
  final Function(Review)? onDelete;

  const ReviewItem({super.key, required this.review, required this.isMyReview, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = review.userAvatarUrl;
    final hasAvatar =
        avatarUrl.isNotEmpty && Uri.tryParse(avatarUrl)?.isAbsolute == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: hasAvatar
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    review.userName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (isMyReview) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppColors.tabInactive,
                    onPressed: () {
                      onEdit?.call(review);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: AppColors.redWarm,
                    onPressed: () {
                      onDelete?.call(review);
                    },
                  ),
                ]
              ],
            ),
            const SizedBox(height: 8),
            RatingWidget(rating: review.rate.toDouble()),
            const SizedBox(height: 8),
            ExpandableText(
              key: Key(review.id),
              text: review.text,
              maxLines: 3,
            ),
            const SizedBox(height: 6),
            Text(
              formatReviewDate(review.date),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
