import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/core/utils/utils.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finder_bloc.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finder_event.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finser_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/books_list/book_item.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/barcode_scanner_dialog.dart';

class FinderScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FinderBloc>()..add(FinderLoadBooksEvent()),
      child: Scaffold(
          appBar: AppBar(title: Text("Пошук книги")),
          body: Column(
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  _searchController.addListener(() {
                    setState(() {});
                  });

                  return Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: "Введіть назву...",
                            prefixIcon: _searchController.text.isEmpty
                                ? Icon(Icons.search)
                                : Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context
                                    .read<FinderBloc>()
                                    .add(FinderSearchQueryChangedEvent(''));
                              },
                            )),
                        onChanged: (query) {
                          context
                              .read<FinderBloc>()
                              .add(FinderSearchQueryChangedEvent(query));
                        },
                      ),
                      SizedBox(height: 26),
                      IconButton(
                        icon: Icon(Icons.camera_alt, size: 90),
                        onPressed: () async {
                          final result = await showDialog<String>(
                            context: context,
                            builder: (_) => const BarcodeScannerDialog(),
                          );

                          if (result != null) {
                            _searchController.value =
                                TextEditingValue(text: result);
                            context
                                .read<FinderBloc>()
                                .add(FinderSearchQueryChangedEvent(result));
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                  height: 1,
                  width: double.infinity,
                  child: Container(
                    color: AppColors.cardBackground2,
                  )),
              SizedBox(height: 16),
              BlocBuilder<FinderBloc, FinderState>(
                builder: (context, state) {
                  if (state is BooksInitialState) {
                    return Center(
                        child: Column(
                      children: [Text("Сканувати книгу")],
                    ));
                  }
                  if (state is FinderBooksListState) {
                    return Expanded(
                        child: StreamBuilder<List<Book>>(
                      stream: state.booksStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());

                        final books = snapshot.data!;

                        final searchText = _searchController.text.trim();
                        final isBarcode = isNumeric(searchText);

                        return searchText.isEmpty && books.isEmpty
                            ? Center(
                                child: Text(
                                    "Введіть назву книги або зіскануйте Штрихкод"))
                            : books.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text(isBarcode
                                            ? "Книги з таким ШК не знайдено. Спробуйте знайти за назвою, або додайте ШК до існуючої книги в розділі  Books"
                                            : "Книги з такою назвою не знайдено. Додати нову книгу?"),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            //go to create book

                                            context.push(AppRoutes.addBook,
                                                extra: searchText);
                                          },
                                          child: Text(isBarcode
                                              ? "Додати нову книгу зі ШК"
                                              : "Додати нову книгу"),
                                        ),
                                      ],
                                    ))
                                : ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                            height: 0.5,
                                            color: Colors.grey[300]),
                                    itemCount: books.length,
                                    itemBuilder: (context, index) => BookItem(
                                      book: books[index],
                                      onTap: (book) {
                                        // context.read<BooksListBloc>().add(BookSelectedEvent(book));
                                        print("-------book.id = ${book.id}");
                                        context.push(AppRoutes.createLoan,
                                            extra: book);
                                      },
                                      onScanTap: (book) async {
                                        //context.read<BooksListBloc>().add(BookSelectedEvent(book));
                                        /*final result = await showDialog<String>(
                                      context: context,
                                      builder: (_) =>
                                          const BarcodeScannerDialog(),
                                    );

                                    if (result != null) {
                                      //_searchController.value = TextEditingValue(text: result);
                                      // context.read<BooksListBloc>().add(SearchQueryChangedEvent(result));

                                      //   context.read<BooksListBloc>().add(UpdateBarcode(book.id, result));
                                    }*/
                                      },
                                    ),
                                  );
                      },
                    ));
                  } else if (state is BooksErrorState) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          )),
    );
  }
}
