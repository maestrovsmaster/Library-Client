import 'package:equatable/equatable.dart';

abstract class LoansListEvent extends Equatable {
  const LoansListEvent();

  @override
  List<Object> get props => [];
}

class LoadLoansEvent extends LoansListEvent {}

class SearchQueryChangedEvent extends LoansListEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object> get props => [query];
}


