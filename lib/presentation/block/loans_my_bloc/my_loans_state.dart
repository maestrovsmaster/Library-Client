import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/loan.dart';

abstract class MyLoansListState extends Equatable {
  const MyLoansListState();

  @override
  List<Object> get props => [];
}

class LoansInitialState extends MyLoansListState {}

class LoansListState extends MyLoansListState {
  final List<Loan> loans;

  const LoansListState(this.loans);

  @override
  List<Object> get props => [loans];
}

class LoansErrorState extends MyLoansListState {
  final String message;

  const LoansErrorState(this.message);

  @override
  List<Object> get props => [message];
}
