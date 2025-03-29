import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_bloc.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_event.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_state.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loan_item.dart';

class LoansListScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  LoansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoansListBloc>()..add(LoadLoansEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: StatefulBuilder(
            builder: (context, setState) {
              _searchController.addListener(() {
                setState(() {});
              });

              return Container();/*TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Пошук читача...",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context
                          .read<LoansListBloc>()
                          .add(SearchQueryChangedEvent(''));
                    },
                  )
                      : null,
                ),
                onChanged: (query) {
                  context
                      .read<LoansListBloc>()
                      .add(SearchQueryChangedEvent(query));
                },
              );*/
            },
          ),
        ),
        body: BlocBuilder<LoansListBloc, LoansListState>(
          builder: (context, state) {
            if (state is LoansStreamState) {
              return StreamBuilder<List<Loan>>(
                stream: state.loansStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final loans = snapshot.data!;

                  return loans.isEmpty
                      ? Center(child: Text("Немає активних позик"))
                      : ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(height: 0.5, color: Colors.grey[300]),
                    itemCount: loans.length,
                    itemBuilder: (context, index) => LoanItem(
                      loan: loans[index],
                      onTap: (loan) {
                        // context.read<LoansListBloc>().add(LoanSelectedEvent(loan));
                      },
                    ),
                  );
                },
              );
            } else if (state is LoansErrorState) {
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
