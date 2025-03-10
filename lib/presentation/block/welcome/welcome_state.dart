import 'package:equatable/equatable.dart';

abstract class WelcomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WelcomeInitial extends WelcomeState {}

class WelcomeChecking extends WelcomeState {}

class WelcomeAuthenticated extends WelcomeState {}

class WelcomeUnauthenticated extends WelcomeState {}
