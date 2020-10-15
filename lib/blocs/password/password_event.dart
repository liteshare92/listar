import 'package:meta/meta.dart';

@immutable
abstract class PasswordEvent {}

class OnChangePassword extends PasswordEvent {
  final String password;
  OnChangePassword({this.password});
}

class OnForgotPassword extends PasswordEvent {
  final String email;
  OnForgotPassword({this.email});
}
