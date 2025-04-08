import 'package:equatable/equatable.dart';

abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object> get props => [];
}

class BookInitialState extends BookDetailsState {}