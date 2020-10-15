import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

import 'bloc.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(InitialEditProfileState());
  UserRepository userRepository = UserRepository();

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is OnChangeProfile) {
      yield FetchingEditProfile();

      ///Fetch change profile
      final ResultApiModel result = await userRepository.changeProfile(
        name: event.name,
        email: event.email,
        website: event.website,
        information: event.information,
      );

      ///Case success
      if (result.success) {
        Application.user.name = result.data['name'] ?? Application.user.name;
        Application.user.email = result.data['email'] ?? Application.user.email;
        Application.user.link = result.data['url'] ?? Application.user.link;
        Application.user.description =
            result.data['description'] ?? Application.user.description;

        ///Save to Storage user via repository
        await userRepository.saveUser(user: Application.user);

        ///Notify loading to UI
        yield EditProfileSuccess();
      } else {
        ///Notify loading to UI
        yield EditProfileFail(code: result.code);
      }
    }
  }
}
