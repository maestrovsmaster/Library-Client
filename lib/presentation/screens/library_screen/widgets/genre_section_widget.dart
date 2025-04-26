import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/library_screen/widgets/book_tile.dart';

class GenreSectionWidget extends StatelessWidget {
  final String genreTitle;
  final String genreId;

  const GenreSectionWidget({required this.genreTitle, required this.genreId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(children:[
            Text(
              genreTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                //context.push('/genre/$genreId');
                context.push(AppRoutes.genre, extra: genreId);
              },
              child: Text("перейти>", style: Theme.of(context).textTheme.bodyMedium),
            )
          ])

        ),
        SizedBox(
          height: 200,
          child: StreamBuilder<List<Book>>(
            stream: sl<BooksRepository>().booksStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              final books = snapshot.data!
                  .where((b) => b.genre.toLowerCase() == genreId.toLowerCase())
                  .take(5)
                  .toList();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BookTile(book: books[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
