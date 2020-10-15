import 'package:meta/meta.dart';

@immutable
abstract class LoginState {}

class InitialLoginState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFail extends LoginState {
  final String code;

  LoginFail(this.code);
}

class LoginSuccess extends LoginState {}

class LogoutLoading extends LoginState {}

class LogoutFail extends LoginState {
  final String message;

  LogoutFail(this.message);
}

class LogoutSuccess extends LoginState {}
