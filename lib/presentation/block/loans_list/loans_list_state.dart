import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/loan.dart';

abstract class LoansListState extends Equatable {
  const LoansListState();

  @override
  List<Object> get props => [];
}

class LoansInitialState extends LoansListState {}

class LoansStreamState extends LoansListState {
  final Stream<List<Loan>> loansStream;

  const LoansStreamState(this.loansStream);

  @override
  List<Object> get props => [loansStream];
}

class LoansErrorState extends LoansListState {
  final String message;

  const LoansErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class LoanClosed extends LoansListState {}

class LoanCloseError extends LoansListState {
  final String message;
  const LoanCloseError(this.message);
  @override
  List<Object> get props => [message];
}