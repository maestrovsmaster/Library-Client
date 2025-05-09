import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/review.dart';
import 'package:leeds_library/presentation/widgets/create_rating_bar.dart';


Future<ReviewResult?> showCreateReviewDialog(BuildContext context, Book book, {Review? review}) async {
  return showDialog<ReviewResult>(
    context: context,
    builder: (context) => CreateReviewDialog(book: book, review: review),
  );
}

class CreateReviewDialog extends StatefulWidget {
  final Book book;
  final Review? review;

  const CreateReviewDialog({super.key, required this.book, this.review});

  @override
  State<CreateReviewDialog> createState() => _CreateReviewDialogState();
}

class _CreateReviewDialogState extends State<CreateReviewDialog> {
  double _rating = 0;
  final _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.review != null) {
      print("asdfsdfsdfsdfsdfsdf");
      _rating = widget.review!.rate.toDouble();
      _controller.text = widget.review!.text;
    }
  }

  @override
  Widget build(BuildContext context) {




    return AlertDialog(
      title: Text("Написати відгук для книжки '${widget.book.title}'"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CreateRatingBar(
            rating: _rating,
            onChanged: (val) => setState(() => _rating = val),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Ваш відгук...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (_rating > 0 && text.isNotEmpty) {
              Navigator.of(context).pop(ReviewResult(
                rating: _rating,
                text: text,
              ));
            }
          },
          child: const Text('Ок'),
        ),
      ],
    );
  }
}

class ReviewResult {
  final double rating;
  final String text;

  ReviewResult({required this.rating, required this.text});
}