import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}


class FetchAccount extends AccountEvent {}

class LogOut extends AccountEvent {}

class LogIn extends AccountEvent {}