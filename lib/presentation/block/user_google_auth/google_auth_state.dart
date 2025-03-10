import 'package:firebase_auth/firebase_auth.dart';
import 'package:leeds_library/data/models/app_user.dart';

abstract class GoogleAuthState {}
class GoogleAuthInitial extends GoogleAuthState {}
class GoogleAuthLoading extends GoogleAuthState {}
class GoogleAuthenticated extends GoogleAuthState {
  final User user;
  GoogleAuthenticated(this.user);
}
class GoogleUnauthenticated extends GoogleAuthState {}

class Authenticated extends GoogleAuthState {
  final AppUser user;
  Authenticated(this.user);
}