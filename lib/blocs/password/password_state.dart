import 'package:meta/meta.dart';

@immutable
abstract class PasswordState {}

class InitialPasswordState extends PasswordState {}

class FetchingChangePassword extends PasswordState {}

class ChangePasswordSuccess extends PasswordState {}

class ChangePasswordFail extends PasswordState {
  final String code;
  ChangePasswordFail({this.code});
}

class FetchingForgotPassword extends PasswordState {}

class ForgotPasswordSuccess extends PasswordState {}

class ForgotPasswordFail extends PasswordState {
  final String code;
  ForgotPasswordFail({this.code});
}
