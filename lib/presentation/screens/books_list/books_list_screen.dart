import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/books_list/books_list_event.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/barcode_scanner_dialog.dart';

import 'book_item.dart';

class BooksListScreen extends StatelessWidget {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BooksListBloc>()..add(LoadBooksEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: StatefulBuilder(
            builder: (context, setState) {
              _searchController.addListener(() {
                setState(() {});
              });

              return TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Пошук книги...",
                  prefixIcon: _searchController.text.isEmpty
                      ? Icon(Icons.search)
                      : Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context
                          .read<BooksListBloc>()
                          .add(SearchQueryChangedEvent(''));
                    },
                  )
                      : IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async{
                      final result = await showDialog<String>(
                        context: context,
                        builder: (_) => const BarcodeScannerDialog(),
                      );

                      if (result != null) {
                        _searchController.value = TextEditingValue(text: result);
                        context.read<BooksListBloc>().add(SearchQueryChangedEvent(result));
                      }
                    },
                  ),
                ),
                onChanged: (query) {
                  context
                      .read<BooksListBloc>()
                      .add(SearchQueryChangedEvent(query));
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
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());



                  final books = snapshot.data!;



                  return books.isEmpty
                      ? Center(child: Text("Нічого не знайдено"))
                      : ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(height: 0.5, color: Colors.grey[300]),
                          itemCount: books.length,
                          itemBuilder: (context, index) => BookItem(
                              book: books[index],
                              onTap: (book) {
                                context.push(AppRoutes.bookDetails, extra: book);
                              },
                             onScanTap: (book) async{
                                //context.read<BooksListBloc>().add(BookSelectedEvent(book));
                               final result = await showDialog<String>(
                                 context: context,
                                 builder: (_) => const BarcodeScannerDialog(),
                               );

                               if (result != null) {
                                 //_searchController.value = TextEditingValue(text: result);
                                // context.read<BooksListBloc>().add(SearchQueryChangedEvent(result));

                                 context.read<BooksListBloc>().add(UpdateBarcode(book.id, result));

                               }
                             },

                              ),
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
