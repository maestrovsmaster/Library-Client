import 'package:leeds_library/data/models/review.dart';

abstract class ReviewsEvent {}

class InitialEvent extends ReviewsEvent {}

class LoadReviewsEvent extends ReviewsEvent {
  final String bookId;
  LoadReviewsEvent(this.bookId);
}

class CreateReviewEvent extends ReviewsEvent {
  final Review review;
  CreateReviewEvent(this.review);
}

class UpdateReviewEvent extends ReviewsEvent {
  final String reviewId;
  final int rate;
  final String text;
  UpdateReviewEvent({required this.reviewId, required this.rate, required this.text});
}

class DeleteReviewEvent extends ReviewsEvent {
  final String reviewId;
  DeleteReviewEvent(this.reviewId);
}

