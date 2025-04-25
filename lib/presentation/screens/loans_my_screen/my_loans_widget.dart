import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/presentation/block/loans_my_bloc/my_loans_bloc.dart';
import 'package:leeds_library/presentation/block/loans_my_bloc/my_loans_event.dart';
import 'package:leeds_library/presentation/block/loans_my_bloc/my_loans_state.dart';
import 'package:leeds_library/presentation/screens/loans_list_screen/loan_item.dart';

class LoansListScreen extends StatefulWidget {
  const LoansListScreen({super.key});

  @override
  State<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends State<LoansListScreen> {
  List<Loan>? _loans;

  @override
  void initState() {
    super.initState();

    context.read<MyLoansListBloc>().add(LoadLoansEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyLoansListBloc, MyLoansListState>(
      listener: (BuildContext context, state) {
        if (state is LoansErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is LoansListState) {
          _loans = state.loans;
        }

        if (_loans == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // return _loans.isEmpty
        // ? const Center(child: Text("Немає активних позик"))
        return ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(height: 0.5, color: Colors.grey[300]),
          itemCount: _loans!.length,
          itemBuilder: (context, index) => LoanItem(
            loan: _loans![index],
            onTap: (loan) {
              // context.read<LoansListBloc>().add(LoanSelectedEvent(loan));
              //  context.read<LoansListBloc>().add(CloseLoanEvent(loan.id!, loan.book['id']));
            },
          ),
        );
      },
    );
  }
}
