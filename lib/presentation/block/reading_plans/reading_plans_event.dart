import 'package:equatable/equatable.dart';

abstract class ReadingPlansEvent extends Equatable {
  const ReadingPlansEvent();

  @override
  List<Object> get props => [];
}



class LoadPlansEvent extends ReadingPlansEvent {}

