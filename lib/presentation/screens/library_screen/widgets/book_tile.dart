import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.bookDetails, extra: book);
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(book.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: 100,
            child: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
