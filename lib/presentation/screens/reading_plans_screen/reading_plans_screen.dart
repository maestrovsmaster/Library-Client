import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_bloc.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_event.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_state.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loan_item.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loans_list_screen.dart';
import 'package:leeds_library/presentation/screens/loans_my_screen/my_loan_item.dart';

import '../loans_my_screen/my_loans_widget.dart';
import 'reading_item.dart';

class ReadingPlansScreen extends StatefulWidget {

  @override
  State<ReadingPlansScreen> createState() {
    return _ReadingPlansScreenState();
  }
}

class _ReadingPlansScreenState extends State<ReadingPlansScreen> {


  List<Book>? _books;
  List<Loan>? _loans;


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
            _loans = state.loans;
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Я зараз читаю',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                 // MyLoansWidget()
                ),
              ),


              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => MyLoanItem(
                        loan: _loans![index],
                        onTap: (loan) {
                          // context.read<LoansListBloc>().add(LoanSelectedEvent(loan));
                          //  context.read<LoansListBloc>().add(CloseLoanEvent(loan.id!, loan.book['id']));
                        },
                      ),
                  childCount: _loans!.length, // або кількість ваших елементів
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Плани читання',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),


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