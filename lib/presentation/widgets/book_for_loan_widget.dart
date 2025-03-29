import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leeds_library/data/models/book.dart';

class BookForLoanWidget extends StatelessWidget {
  final Book book;
  final Function(Book) onBook;
  final Function(Book) onReturn;

  const BookForLoanWidget(
      {super.key,
      required this.book,
      required this.onBook,
      required this.onReturn});

  @override
  Widget build(BuildContext context) {
    final isAvailable = book.isAvailable;
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
            padding: const EdgeInsets.all(4),
            child: InkWell(
                onTap: () {},
                child: SizedBox(
                    height: 216,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Column(children: [
                          Row(children: [
                            CachedNetworkImage(
                              imageUrl: book.imageUrl,
                              width: 70,
                              height: 130,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 60,
                                height: 70,
                                color: Colors.grey[300],
                                child: Center(),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                  Icons.broken_image,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  SizedBox(height: 4),
                                  Text(isAvailable ? "Вільна" : "Заброньована",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ))
                                ],
                              ),
                            )),
                          ]),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextButton(
                                  onPressed: () {
                                    !isAvailable
                                        ? onBook(book)
                                        : onReturn(book);
                                  },
                                  child: Text(
                                      !isAvailable
                                          ? "Забронювати?"
                                          : "Повернути?",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      )),
                                )),
                                SizedBox(height: 12),
                                Expanded(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    isAvailable ? onBook(book) : onReturn(book);
                                  },
                                  child: Text(
                                      isAvailable ? "Забронювати" : "Повернути",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      )),
                                )),
                              ],
                            ),
                          )
                        ]))))));
  }
}
