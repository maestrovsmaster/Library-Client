import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  const ImageDialog({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 2;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: screenWidth,
              height: imageHeight,
              color: Colors.grey[200],
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.book,
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.close,
                size: 22,
                color: Colors.black,
              ),
            ),

          ),

        ],
      ),
    );
  }
}
