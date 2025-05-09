import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/images_composition_widget.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksRepo = sl<BooksRepository>();//,context.read<BooksRepository>();

    return Scaffold(
      appBar: AppBar(title: Text("Жанри")),
      body: StreamBuilder<List<Book>>(
        stream: sl<BooksRepository>().booksStream, //booksRepo.booksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!;
          final categories = sl<BooksRepository>().getCategories().map((e) => e.name).toList(); //booksRepo.catetories.toSet().toList();

          print("categories: $categories");

          return ListView.separated(
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(), // якщо хочеш iOS-ефект
            cacheExtent: 500, // прокешувати більше екранів наперед
            separatorBuilder: (_, __) => Divider(height: 0, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final genre = categories[index];
              final genreBooks = books
                  .where((book) => book.genre.toLowerCase() == genre.toLowerCase())
                  .take(3)
                  .toList();

              return ListTile(

                key: ValueKey(genre),
                onTap: () {
                 // context.push('/genre/$genre');
                  context.push(AppRoutes.genre, extra: genre);

                },

                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: [
                    ImagesCompositionWidget(
                      key: ValueKey(genre),
                      genre: genre,
                      allBooks: books,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        genre,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
