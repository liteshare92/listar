import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:listar/api/http_manager.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/authentication/bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthBloc() : super(InitialAuthenticationState());
  final UserRepository userRepository = UserRepository();

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is OnAuthCheck) {
      ///Notify state AuthenticationBeginCheck
      yield AuthenticationBeginCheck();
      final hasUser = userRepository.getUser();

      if (hasUser != null) {
        ///Getting data from Storage
        final user = UserModel.fromJson(jsonDecode(hasUser));

        ///Set token network
        httpManager.baseOptions.headers["Authorization"] =
            "Bearer " + user.token;

        ///Valid token server
        final ResultApiModel result = await userRepository.validateToken();

        ///Fetch api success
        if (result.success) {
          ///Set user
          Application.user = user;
          yield AuthenticationSuccess();

          ///Load wishList
          AppBloc.wishListBloc.add(OnLoadWishList());
        } else {
          ///Fetch api fail
          ///Delete user when can't verify token
          await userRepository.deleteUser();

          ///Notify loading to UI
          yield AuthenticationFail();
        }
      } else {
        ///Notify loading to UI
        yield AuthenticationFail();
      }
    }

    if (event is OnSaveUser) {
      ///Save to Storage user via repository
      final savePreferences = await userRepository.saveUser(user: event.user);

      ///Check result save user
      if (savePreferences) {
        ///Set token network
        httpManager.baseOptions.headers["Authorization"] =
            "Bearer " + event.user.token;

        ///Set user
        Application.user = event.user;

        ///Notify loading to UI
        yield AuthenticationSuccess();

        ///Load wishList
        AppBloc.wishListBloc.add(OnLoadWishList());
      } else {
        final String message = "Cannot save user data to storage phone";
        throw Exception(message);
      }
    }

    if (event is OnClear) {
      ///Delete user
      final deletePreferences = await userRepository.deleteUser();

      ///Clear user Storage user via repository
      Application.user = null;

      ///Clear token httpManager
      httpManager.baseOptions.headers = {};

      ///Check result delete user
      if (deletePreferences) {
        yield AuthenticationFail();
      } else {
        final String message = "Cannot delete user data to storage phone";
        throw Exception(message);
      }
    }
  }
}
