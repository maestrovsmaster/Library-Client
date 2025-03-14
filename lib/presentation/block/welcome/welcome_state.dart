import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/app_user.dart';

abstract class WelcomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WelcomeInitial extends WelcomeState {}

class WelcomeChecking extends WelcomeState {}

class WelcomeAuthenticated extends WelcomeState {}

class WelcomeUnauthenticated extends WelcomeState {}

class UserNotCompleted extends WelcomeState {
  final AppUser user;
  UserNotCompleted(this.user);

}
