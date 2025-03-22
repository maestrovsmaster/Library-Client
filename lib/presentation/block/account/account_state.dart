import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/app_user.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitialState extends AccountState {}

class AccountLoadingState extends AccountState {}

class FetchedUserState extends AccountState {
  final AppUser user;

  const FetchedUserState(this.user);

  @override
  List<Object> get props => [user];
}

class AccountErrorState extends AccountState {
  final String message;

  const AccountErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AccountLoggedOutState extends AccountState {}


