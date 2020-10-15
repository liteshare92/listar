import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

import 'bloc.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc() : super(InitialPasswordState());
  final UserRepository userRepository = UserRepository();

  @override
  Stream<PasswordState> mapEventToState(event) async* {
    if (event is OnChangePassword) {
      yield FetchingChangePassword();

      ///Fetch change password
      final ResultApiModel result = await userRepository.changePassword(
        password: event.password,
      );

      ///Case success
      if (result.success) {
        ///Notify loading to UI
        yield ChangePasswordSuccess();
      } else {
        ///Notify loading to UI
        yield ChangePasswordFail(code: result.code);
      }
    }

    if (event is OnForgotPassword) {
      yield FetchingForgotPassword();

      ///Fetch change password
      final ResultApiModel result = await userRepository.forgotPassword(
        email: event.email,
      );

      ///Case success
      if (result.success) {
        ///Notify loading to UI
        yield ForgotPasswordSuccess();
      } else {
        ///Notify loading to UI
        yield ForgotPasswordFail(code: result.code);
      }
    }
  }
}
