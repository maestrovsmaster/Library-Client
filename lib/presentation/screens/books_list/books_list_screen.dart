import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/books_list/books_list_event.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_state.dart';


import 'book_item.dart';

class BooksListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BooksListBloc>()..add(LoadBooksEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<BooksListBloc, BooksListState>(
            builder: (context, state) {
              return TextField(
                decoration: InputDecoration(
                  hintText: "Пошук книги...",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // TODO: Реалізувати сканування штрихкоду
                    },
                  ),
                ),
                onChanged: (query) {
                  context.read<BooksListBloc>().add(SearchQueryChangedEvent(query));
                },
              );
            },
          ),
        ),
        body: BlocBuilder<BooksListBloc, BooksListState>(
          builder: (context, state) {
            if (state is BooksStreamState) {
              return StreamBuilder<List<Book>>(
                stream: state.booksStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final books = snapshot.data!;
                  return books.isEmpty
                      ? Center(child: Text("Нічого не знайдено"))
                      : ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) => BookItem(book: books[index]),
                  );
                },
              );
            } else if (state is BooksErrorState) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
