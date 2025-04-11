import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/books_list/books_list_event.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_state.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_bloc.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_event.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/animated_checkmark.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/barcode_scanner_dialog.dart';

import 'reading_item.dart';

class ReadingPlansScreen extends StatefulWidget {

  @override
  State<ReadingPlansScreen> createState() {
    return _ReadingPlansScreenState();
  }
}

class _ReadingPlansScreenState extends State<ReadingPlansScreen> {

 // Stream<List<Book>>? _booksStream;

  List<Book>? _books;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadingPlansBloc>().add(LoadPlansEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("План читання"),
      ),

      body: BlocConsumer<ReadingPlansBloc, ReadingPlansState>(
        listener: (BuildContext context,  state) {
          if (state is BooksListErrorState) {
            _showDialog(context, state.message);
          }

        },
        builder: (context, state) {

          if(state is BooksListLoadedState){
           // _booksStream = context.read<BooksListBloc>().filteredBooksStream;
            _books = state.books;

          }

          if(state is BooksListErrorState){
            return Center(child: Text(state.message));
          }

          //display list

          return _books == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(

            itemCount: _books!.length,
            itemBuilder: (context, index) => ReadingItem(
              book: _books![index],
              onDeleteTap: (book) {
                // context.push(AppRoutes.bookDetails, extra: book);
              },

            ),
          );

          //show list of books





         /* final isStreamActive = _booksStream != null;
          return !isStreamActive ? Center(child: CircularProgressIndicator()) :

          StreamBuilder<List<Book>>(
            stream: context.read<BooksListBloc>().filteredBooksStream, //state.booksStream,
            builder: (context, snapshot) {

              if(snapshot.data == null){
                return Center(child: CircularProgressIndicator());
              }
              final books = snapshot.data!;



              return books.isEmpty
                  ? Center(child: Text("Нічого не знайдено"))
                  : ListView.builder(

                itemCount: books.length,
                itemBuilder: (context, index) => ReadingItem(
                  book: books[index],
                  onDeleteTap: (book) {
                   // context.push(AppRoutes.bookDetails, extra: book);
                  },

                ),
              );
            },
          );*/



        },
      ),
    );
  }

  _showDialog(BuildContext context, String message){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Помилка"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

}