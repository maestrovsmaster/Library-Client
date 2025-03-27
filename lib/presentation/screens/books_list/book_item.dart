import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leeds_library/data/models/book.dart';

class BookItem extends StatelessWidget {
  final Book book;
  final Function(Book) onTap;
  final Function(Book) onScanTap;

  const BookItem({Key? key, required this.book, required this.onTap, required this.onScanTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 146,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(children: [
            /* book.imageUrl.isNotEmpty
            ? Image.network(book.imageUrl,
                width: 80, height: 130, fit: BoxFit.cover)
            : Icon(Icons.book, size: 50),*/

            CachedNetworkImage(
              imageUrl: book.imageUrl,
              width: 80,
              height: 130,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 90,
                height: 126,
                color: Colors.grey[300],
                child: Center(), // Або анімація
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.broken_image, size: 50, color: Colors.grey[300]),
            ),
            SizedBox(width: 16),
            Expanded(
                child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(book.author),
                  SizedBox(height: 4),
                  Text(book.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 12,
                    width: 12,
                    child: book.barcode.isNotEmpty
                        ? Icon(Icons.qr_code, color: Colors.green)
                        : Container(),
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: SizedBox(
                height: 44,
                width: 44,
                child: book.barcode.isNotEmpty
                    ? Container() : GestureDetector(
                        onTap: () {
                          print('SVG tapped!');
                          onScanTap(book);
                        },
                        child: SvgPicture.asset(
                          'assets/images/ic_barcode_scanner.svg',
                          width: 36,
                          height: 36,
                        ),
                      )
                    ,
              ),
            )
          ]),
        ));
  }
}
