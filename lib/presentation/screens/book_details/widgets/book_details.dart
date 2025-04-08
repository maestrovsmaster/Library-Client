import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/widgets/book_image.dart';
import 'package:leeds_library/presentation/widgets/genre_widget.dart';
import 'package:leeds_library/presentation/widgets/rating_genre_widget.dart';
import 'package:leeds_library/presentation/widgets/rating_widget.dart';

class BookDetails extends StatelessWidget {
  final Book book;

  const BookDetails({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.3;
    final imageHeight = imageWidth * 1.5;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0, top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: BookImage(imageUrl: book.imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      book.author,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black.withAlpha(180)),
                    )),
                const SizedBox(height: 12),
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      book.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black.withAlpha(200)),
                      // maxLines: 2,
                      //  overflow: TextOverflow.ellipsis,
                    )),
                const SizedBox(height: 8),
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      book.publisher,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey.withAlpha(250)),
                    )),
                const SizedBox(height: 20),


                RatingGenreWidget(rating: book.averageRating ?? 0, genre: book.genre)

              ],
            ),
          ),
        ],
      ),
    );
  }
}
