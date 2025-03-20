import 'package:firebase_auth/firebase_auth.dart';
import 'package:leeds_library/data/models/app_user.dart';

abstract class GoogleAuthState {}
class GoogleAuthInitial extends GoogleAuthState {}
class GoogleAuthLoading extends GoogleAuthState {}

class GoogleUnauthenticated extends GoogleAuthState {}

class Authenticated extends GoogleAuthState {
  final AppUser user;
  Authenticated(this.user);
}

class AuthenticatedButNotCompleted extends GoogleAuthState {
  final AppUser user;
  AuthenticatedButNotCompleted(this.user);
}