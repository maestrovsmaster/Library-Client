import 'package:equatable/equatable.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitialState extends CategoriesState {}


class CategoriesListState extends CategoriesState {
  final List<String> categories;

  const CategoriesListState(this.categories);

  @override
  List<Object> get props => [categories];
}


class CategoriesErrorState extends CategoriesState {
  final String message;

  const CategoriesErrorState(this.message);

  @override
  List<Object> get props => [message];
}