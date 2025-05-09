import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leeds_library/data/models/book.dart';

class BookWidget extends StatelessWidget {
  final Book book;
  final Function(Book) onTap;

  const BookWidget({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Padding(
            padding: const EdgeInsets.all(4),
            child: InkWell(
                onTap: () => onTap(book),
                child: SizedBox(
                    height: 116,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: Row(children: [


                        CachedNetworkImage(
                          imageUrl: book.imageUrl,
                          width: 60,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 70,
                            height: 96,
                            color: Colors.grey[300],
                            child: Center(),
                          ),
                          errorWidget: (context, url, error) => Icon(
                              Icons.book,
                              size: 50,
                              color: Colors.grey[300]),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              SizedBox(height: 4),
                              Text(book.barcode.isNotEmpty ? book.barcode : "",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ))
                            ],
                          ),
                        )),

                      ]),
                    )))));
  }
}
