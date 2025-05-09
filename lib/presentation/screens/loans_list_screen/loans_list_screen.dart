import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_bloc.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_event.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_state.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loan_item.dart';
import 'package:leeds_library/presentation/widgets/animated_checkmark.dart';

class LoansListScreen extends StatefulWidget {
  const LoansListScreen({super.key});

  @override
  State<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends State<LoansListScreen> {
  late final TextEditingController _searchController;

  Stream<List<Loan>>? _loansStream;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {}); // для оновлення кнопки очищення
      });

    context.read<LoansListBloc>().add(LoadLoansEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:    Text("Позики",),
        /*TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Пошук читача...",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
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
        ),*/
      ),
      body: BlocConsumer<LoansListBloc, LoansListState>(
        listener: (BuildContext context, state) {
          if (state is LoansErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is LoanClosed) {
            showCheckmark(context);
          }
        },
        builder: (context, state) {
          if (state is LoansStreamState) {
            _loansStream = state.loansStream;
          }

          final isStreamActive = _loansStream != null;
          return !isStreamActive ? Center(child: CircularProgressIndicator()) :
             StreamBuilder<List<Loan>>(
              stream: _loansStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final loans = snapshot.data!;
                return loans.isEmpty
                    ? const Center(child: Text("Немає активних позик"))
                    : ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(height: 0.5, color: Colors.grey[300]),
                  itemCount: loans.length,
                  itemBuilder: (context, index) => LoanItem(
                    loan: loans[index],
                    onTap: (loan) {
                      // context.read<LoansListBloc>().add(LoanSelectedEvent(loan));
                      context.read<LoansListBloc>().add(CloseLoanEvent(loan.id!, loan.book.id));
                    },
                  ),
                );
              },
            );
          /*else if (state is LoansErrorState) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }*/
        },
      ),
    );
  }
}
