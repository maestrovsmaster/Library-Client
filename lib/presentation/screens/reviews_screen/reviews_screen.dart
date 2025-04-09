import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/review.dart';
import 'package:leeds_library/presentation/block/reviews/reviews_bloc.dart';
import 'package:leeds_library/presentation/block/reviews/reviews_event.dart';
import 'package:leeds_library/presentation/block/reviews/reviews_state.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/screens/reviews_screen/review_item.dart';
import 'package:leeds_library/presentation/screens/reviews_screen/widgets/create_review_dialog.dart';
import 'package:leeds_library/presentation/widgets/animated_checkmark.dart';
import 'package:leeds_library/presentation/widgets/confirm_dialog.dart';

class ReviewsList extends StatefulWidget {
  final Book book;

  const ReviewsList({super.key, required this.book});

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  Stream<List<Review>>? _reviewStream;
  List<Review>? _reviewsList;
  @override
  void initState() {
    super.initState();
    context.read<ReviewsBloc>().add(LoadReviewsEvent(widget.book.id));
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = sl<UserCubit>();
    final me = userCubit.state;

    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text("Написати відгук"),
        onPressed: () async {
          print("Create review ..");
          Review? _myPreviousReview = null;
          print("Create review ...");
          if(_reviewsList != null){
            print("Create review 3");
            if(_reviewsList!.isNotEmpty && me != null){
              print("Create review 32");
              //check if review contains users review and save this review
              final isMyReview = _reviewsList!.any((review) => review.userId == me.userId);
              print("Create review 33");
              if(isMyReview){
                print("Create review 34");
                _myPreviousReview = _reviewsList!.firstWhere((review) => review.userId == me.userId);
              }
              print("Create review 4");
            }
            print("Create review 44");
          }
          print("Create review1");
          if(_myPreviousReview == null) {
            print("Create review11");
            _createReview(context);
          }else{
            print("Create review22");
            _editReview(context, _myPreviousReview!);
          }
        },
      ),
      body: BlocConsumer<ReviewsBloc, ReviewsState>(
        listener: (context, state) {
          if (state is ReviewsStreamState) {
            _reviewStream = state.stream;
          }
          if (state is ReviewsErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (_reviewStream == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<List<Review>>(
            stream: _reviewStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());

              final reviews = snapshot.data!;
              _reviewsList = reviews;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final isMyReview =
                      (me != null) ? me.userId == review.userId : false;
                  print(
                      "isMyReview review = ${review.text} reviews size = ${reviews.length}");
                  return ReviewItem(
                      review: review,
                      isMyReview: isMyReview,
                      onEdit: (review) {
                        _editReview(context, review);
                      },
                      onDelete: (review) {
                        _showDeleteReviewDialog(context, review);
                      });
                },
              );
            },
          );
        },
      ),
    );
  }

  void _createReview(BuildContext context) async {
    print("Create review");
    final result = await showCreateReviewDialog(context, widget.book);
    if (result != null) {
      context.read<ReviewsBloc>().add(CreateReviewEvent(
        Review(
          id: '',
          bookId: widget.book.id,
          userId: '',
          userName: '',
          userAvatarUrl: '',
          rate: result.rating.toInt(),
          text: result.text,
          date: DateTime.now(),
        ),
      ));
    }
  }

  void _editReview(BuildContext context, Review review) async {
    final result = await showCreateReviewDialog(context, widget.book, review: review);
    if (result != null) {
      context.read<ReviewsBloc>().add(UpdateReviewEvent(
          reviewId: review.id, rate: result.rating.toInt(), text: result.text));
    }
  }

  void _showDeleteReviewDialog(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title: "Видалити відгук",
          message: "Ви дійсно хочете видалити цей відгук?",
          confirmText: "Видалити",
          cancelText: "Відміна",
          onConfirm: () {
            context.read<ReviewsBloc>().add(DeleteReviewEvent(review.id));
          },
        );
      },
    );
  }
}
