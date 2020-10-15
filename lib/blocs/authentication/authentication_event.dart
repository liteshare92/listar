import 'package:listar/models/model.dart';

abstract class AuthenticationEvent {}

class OnAuthCheck extends AuthenticationEvent {}

class OnSaveUser extends AuthenticationEvent {
  final UserModel user;

  OnSaveUser(this.user);
}

class OnClear extends AuthenticationEvent {}
