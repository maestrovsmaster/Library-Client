import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:shimmer/shimmer.dart';

class ImagesCompositionWidget extends StatelessWidget {
  final String genre;
  final List<Book> allBooks;

  const ImagesCompositionWidget({ Key? key, required this.genre, required this.allBooks}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = 60.0;
    final genreBooks = allBooks
        .where((book) => book.genre.toLowerCase() == genre.toLowerCase())
        .take(3)
        .toList();

    return SizedBox(
      width: size + 40,
      height: size * 1.5,
      child: Stack(
        children: List.generate(genreBooks.length, (index) {
          final book = genreBooks[index];
          return Positioned(
            left: index * 20.0,
            child: _CoverImage(url: book.imageUrl, size: size),
          );
        }),
      ),
    );
  }
}


class _CoverImage extends StatelessWidget {
  final String url;
  final double size;

  const _CoverImage({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size * 1.5,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: size,
            height: size,
            color: Colors.grey[300],
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: Colors.grey[400],
          child: Icon(Icons.book, color: Colors.white),
        ),
      ),
    );
  }
}
