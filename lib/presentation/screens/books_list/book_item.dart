import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/book.dart';

class BookItem extends StatelessWidget {
  final Book book;

  const BookItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: book.imageUrl.isNotEmpty
            ? Image.network(book.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.book, size: 50),
        title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(book.author),
        trailing: book.barcode.isNotEmpty ? Icon(Icons.check, color: Colors.green) : Icon(Icons.qr_code),
        onTap: () {
          // TODO: Додати відкриття деталей книги або сканування barcode
        },
      ),
    );
  }
}
