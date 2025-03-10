import 'package:equatable/equatable.dart';
import 'package:leeds_library/data/models/app_user.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRegister extends RegisterEvent {
  final AppUser user;

  FetchRegister(
      {required this.user});

  @override
  List<Object?> get props => [user];
}

