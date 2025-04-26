import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/books_list/book_item.dart';

class GenreListScreen extends StatelessWidget {
  final String genre;

  const GenreListScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    final booksRepo = sl<BooksRepository>();

    return Scaffold(
      appBar: AppBar(title: Text(genre)),
      body: StreamBuilder<List<Book>>(
        stream: booksRepo.booksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!
              .where((book) => book.genre.toLowerCase() == genre.toLowerCase())
              .toList();

          if (books.isEmpty) {
            return Center(child: Text("Немає книг у жанрі \"$genre\""));
          }

          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (_, __) => Divider(height: 0.5, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final book = books[index];
              return BookItem(
                book: books[index],
                isUserAdmin: false,
                onTap: (book) {
                  context.push(AppRoutes.bookDetails, extra: book);
                },
                onScanTap: (book) async{

                },

              );


            },
          );
        },
      ),
    );
  }
}
