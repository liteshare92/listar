import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(InitialRegisterState());
  final UserRepository userRepository = UserRepository();

  @override
  Stream<RegisterState> mapEventToState(event) async* {
    if (event is OnRegister) {
      yield FetchingRegister();

      ///Fetch register
      final ResultApiModel result = await userRepository.register(
        username: event.username,
        password: event.password,
        email: event.email,
      );

      ///Case success
      if (result.success) {
        ///Notify loading to UI
        yield RegisterSuccess();
      } else {
        ///Notify loading to UI
        yield RegisterFail(code: result.code);
      }
    }
  }
}
