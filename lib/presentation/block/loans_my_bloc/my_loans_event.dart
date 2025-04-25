import 'package:equatable/equatable.dart';

abstract class MyLoansListEvent extends Equatable {
  const MyLoansListEvent();

  @override
  List<Object> get props => [];
}

class LoadLoansEvent extends MyLoansListEvent {}

