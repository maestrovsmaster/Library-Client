import 'package:leeds_library/data/models/review.dart';

abstract class ReviewsState {}

class ReviewsInitialState extends ReviewsState {}

class ReviewsLoadingState extends ReviewsState {}

class ReviewsLoadedState extends ReviewsState {
  final List<Review> reviews;
  ReviewsLoadedState(this.reviews);
}

class ReviewsErrorState extends ReviewsState {
  final String message;
  ReviewsErrorState(this.message);
}

class ReviewActionSuccessState extends ReviewsState {
  final String message;
  final List<Review> updatedReviews;
  ReviewActionSuccessState(this.message, this.updatedReviews);
}

class ReviewsStreamState extends ReviewsState {
  final Stream<List<Review>> stream;
  ReviewsStreamState(this.stream);
}

