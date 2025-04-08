import 'package:flutter/cupertino.dart';

import 'genre_widget.dart';
import 'rating_widget.dart';

class RatingGenreWidget extends StatelessWidget {
  final double rating;
  final String genre;

  const RatingGenreWidget(
      {super.key, required this.rating, required this.genre});

  @override
  Widget build(BuildContext context) {
    if (genre.isEmpty) {
      return RatingWidget(rating: rating);
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final text = genre;
          final textWidth = (text.length * 6.0) + 16;

          final fitsInline = constraints.maxWidth > 160 + textWidth;

          if (fitsInline) {
            return Row(
              children: [
                RatingWidget(rating: rating),
                const Spacer(),
                GenreWidget(genre: genre)
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RatingWidget(rating: rating),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerRight,
                    child:  Wrap(children: [ GenreWidget(genre: genre)])

                )
              ],
            );
          }
        },
      );
    }
  }
}
