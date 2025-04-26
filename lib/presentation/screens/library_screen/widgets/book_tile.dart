import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:shimmer/shimmer.dart';

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
          /*Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(book.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),*/
          CachedNetworkImage(
            imageUrl: book.imageUrl,
            width: 100,
            height: 140,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 140,
                color: Colors.grey[300],
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 100,
              height: 140,
              color: Colors.grey[400],
              child: Icon(Icons.book, color: Colors.white),
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
