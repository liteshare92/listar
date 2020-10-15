import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/authentication/bloc.dart';
import 'package:listar/blocs/login/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState());
  final UserRepository userRepository = UserRepository();

  @override
  Stream<LoginState> mapEventToState(event) async* {
    ///Event for login
    if (event is OnLogin) {
      ///Notify loading to UI
      yield LoginLoading();

      ///Fetch API via repository
      final ResultApiModel result = await userRepository.login(
        username: event.username,
        password: event.password,
      );

      ///Case API fail but not have token
      if (result.success) {
        ///Login API success
        final UserModel user = UserModel.fromJson(result.data);
        try {
          ///Begin start AuthBloc Event AuthenticationSave
          AppBloc.authBloc.add(OnSaveUser(user));

          ///Notify loading to UI
          yield LoginSuccess();
        } catch (error) {
          ///Notify loading to UI
          yield LoginFail(error.toString());
        }
      } else {
        ///Notify loading to UI
        yield LoginFail(result.code);
      }
    }

    ///Event for logout
    if (event is OnLogout) {
      yield LogoutLoading();
      try {
        ///Begin start AuthBloc Event OnProcessLogout
        AppBloc.authBloc.add(OnClear());

        ///Notify loading to UI
        yield LogoutSuccess();
      } catch (error) {
        ///Notify loading to UI
        yield LogoutFail(error.toString());
      }
    }
  }
}
