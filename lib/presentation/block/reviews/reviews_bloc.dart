import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/review.dart';
import 'package:leeds_library/domain/repositories/review_repository.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';

import 'reviews_event.dart';
import 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final ReviewsRepository repository;
  final UserCubit userCubit;

  String? _bookId;
  List<Review> _currentReviews = [];

  ReviewsBloc({required this.repository, required this.userCubit}) : super(ReviewsInitialState()) {
    on<InitialEvent>(_onCallInitialEvent);
    on<LoadReviewsEvent>(_onLoadReviews);
    on<CreateReviewEvent>(_onCreateReview);
    on<UpdateReviewEvent>(_onUpdateReview);
    on<DeleteReviewEvent>(_onDeleteReview);
  }
  Future<void> _onCallInitialEvent(InitialEvent event, Emitter<ReviewsState> emit) async {
    emit(ReviewsInitialState());
  }

  Future<void> _onLoadReviews(LoadReviewsEvent event, Emitter<ReviewsState> emit) async {
    emit(ReviewsLoadingState());

    try {

      final stream = repository.watchReviewsForBook(event.bookId);
      _bookId = event.bookId;
      emit(ReviewsStreamState(stream));
    } catch (e) {
      emit(ReviewsErrorState("Не вдалося завантажити відгуки"));
    }
  }

  Future<void> _onCreateReview(CreateReviewEvent event, Emitter<ReviewsState> emit) async {
    emit(ReviewsLoadingState());

    final completeReview = event.review.copyWith(userId: userCubit.state?.userId ?? "", userName: userCubit.state?.name ?? "", userAvatarUrl: userCubit.state?.photoUrl ?? "");
    final result = await repository.createReview(completeReview);

    if (result.isSuccess) {
      final updated = await repository.getReviewsForBook(_bookId!);
      emit(ReviewActionSuccessState("Відгук додано", updated));
    } else if (result.isFailure) {
      emit(ReviewsErrorState(result.error!));
    } else if (result.isNotFound) {
      // якщо треба — додай обробку
    }
  }

  Future<void> _onUpdateReview(UpdateReviewEvent event, Emitter<ReviewsState> emit) async {
    emit(ReviewsLoadingState());

    final result = await repository.updateReview(event.bookId,  event.reviewId, event.rate, event.text);
    result.when(
      success: (_) async {
        final updated = await repository.getReviewsForBook(_bookId!);
        _currentReviews = updated;
        emit(ReviewActionSuccessState("Відгук оновлено", updated));
      },
      failure: (error) => emit(ReviewsErrorState(error)), notFound: () {  },

    );
  }

  Future<void> _onDeleteReview(DeleteReviewEvent event, Emitter<ReviewsState> emit) async {
    emit(ReviewsLoadingState());

    final result = await repository.deleteReview(event.bookId, event.reviewId);

    if (result.isSuccess) {
      final updated = await repository.getReviewsForBook(_bookId!);
      _currentReviews = updated;
      emit(ReviewActionSuccessState("Відгук видалено", updated));
    } else if (result.isFailure) {
      emit(ReviewsErrorState(result.error!));
    } else if (result.isEmpty) {
      emit(ReviewsErrorState("Відгук не знайдено"));
    }
  }





}
