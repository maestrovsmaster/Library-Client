abstract class GoogleAuthEvent {}
class GoogleSignInEvent extends GoogleAuthEvent {}
class GoogleLogoutEvent extends GoogleAuthEvent {}
class VerifyTokenEvent extends GoogleAuthEvent {
  final String idToken;
  VerifyTokenEvent(this.idToken);
}