import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/widgets/book_image.dart';
import 'package:leeds_library/presentation/widgets/rating_widget.dart';

class ReadingItem extends StatelessWidget {
  final Book book;
  final Function(Book) onDeleteTap;

  const ReadingItem({Key? key, required this.book, required this.onDeleteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: SizedBox(
            height: 146,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Stack(children: [
                  Row(children: [
                    SizedBox(
                      width: 80,
                      height: 130,
                      child: BookImage(imageUrl: book.imageUrl),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(child: Text(book.publisher)),
                              SizedBox(width: 4),
                              if (book.averageRating != null &&
                                  book.averageRating! > 0)
                                RatingWidget(rating: book.averageRating ?? 0.0),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            book.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(book.genre,
                              style: TextStyle(
                                  color: AppColors.actionReturnColor)),
                          SizedBox(height: 4),
                        ],
                      ),
                    )),
                  ]),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child:  IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () => onDeleteTap(book),
                        ),
                      )),
                ]))));
  }
}
