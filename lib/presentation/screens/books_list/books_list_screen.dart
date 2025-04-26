import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/books_list/books_list_event.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_state.dart';
import 'package:leeds_library/presentation/block/user_cubit/user_cubit.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/animated_checkmark.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/barcode_scanner_dialog.dart';

import 'book_item.dart';

class BooksListScreen extends StatefulWidget {

  @override
  State<BooksListScreen> createState() {
    return _BooksListScreenState();
  }
}

class _BooksListScreenState extends State<BooksListScreen> {

  final userCubit =  sl<UserCubit>();

  Stream<List<Book>>? _booksStream;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BooksListBloc>().add(LoadBooksEvent());
    });
  }

  @override
  Widget build(BuildContext context) {

    final role = userCubit.state?.role ?? "reader";
    final isAdmin = (role == "admin" ||  role == "librarian") ?? false;

    return  Scaffold(
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

        body: BlocConsumer<BooksListBloc, BooksListState>(
          listener: (BuildContext context,  state) {
            if (state is BooksErrorState) {
              _showDialog(context, state.message);
            }
            if (state is BarcodeUpdateError) {
              _showDialog(context, state.message);
            }
            if (state is BarcodeUpdated) {
              showCheckmark(context);
            }
          },
          builder: (context, state) {

            if(state is BooksStreamState){
              _booksStream = context.read<BooksListBloc>().filteredBooksStream;
            }

            final isStreamActive = _booksStream != null;
            return !isStreamActive ? Center(child: CircularProgressIndicator()) :

              StreamBuilder<List<Book>>(
              stream: context.read<BooksListBloc>().filteredBooksStream, //state.booksStream,
              builder: (context, snapshot) {
                //if (!snapshot.hasData)
                 // return Center(child: CircularProgressIndicator());


                if(snapshot.data == null){
                  return Center(child: CircularProgressIndicator());
                }
                final books = snapshot.data!;



                return books.isEmpty
                    ? Center(child: Text("Нічого не знайдено"))
                    : ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(height: 0.5, color: Colors.grey[300]),
                  itemCount: books.length,
                  itemBuilder: (context, index) => BookItem(
                    book: books[index],
                    isUserAdmin: isAdmin,
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

                        context.read<BooksListBloc>().add(UpdateBarcode(book.id, result));

                      }
                    },

                  ),
                );
              },
            );



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
