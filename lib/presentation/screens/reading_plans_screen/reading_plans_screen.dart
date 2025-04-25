import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_bloc.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_event.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_state.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loans_list_screen.dart';

import 'reading_item.dart';

class ReadingPlansScreen extends StatefulWidget {

  @override
  State<ReadingPlansScreen> createState() {
    return _ReadingPlansScreenState();
  }
}

class _ReadingPlansScreenState extends State<ReadingPlansScreen> {


  List<Book>? _books;


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
            _books = state.books;
          }

          if(state is BooksListErrorState){
            return Center(child: Text(state.message));
          }

          //display list

          /*return _books == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(

            itemCount: _books!.length,
            itemBuilder: (context, index) => ReadingItem(
              book: _books![index],
              onDeleteTap: (book) {
                // context.push(AppRoutes.bookDetails, extra: book);
              },

            ),
          );*/

          //show lists
          
          if(_books == null){
            return Text("Немає данних");
          }


          return CustomScrollView(
            slivers: [
             /* SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: /*Text(
                    'Header 1',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),*/
                  LoansListScreen()
                ),
              ),*/

              // Перший список
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => ReadingItem(
                        book: _books![index],
                        onDeleteTap: (book) {
                          // context.push(AppRoutes.bookDetails, extra: book);
                        },

                      ),
                  childCount: _books!.length, // або кількість ваших елементів
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Header 2',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),

              // Другий список
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => ReadingItem(
                        book: _books![index],
                        onDeleteTap: (book) {
                          // context.push(AppRoutes.bookDetails, extra: book);
                        },

                      ),
                  childCount: _books!.length, // або кількість ваших елементів
                ),
              ),
            ],
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