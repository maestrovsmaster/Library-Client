import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_dialog.dart';

class BookImage extends StatelessWidget {
  final String imageUrl;

  const BookImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => ImageDialog(imageUrl: imageUrl),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withAlpha(20),
            width: 1,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}

