import 'dart:convert';

import 'package:listar/api/api.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';

class UserRepository {
  ///Fetch api login
  Future<dynamic> login({String username, String password}) async {
    final params = {"username": username, "password": password};
    return await Api.login(params);
  }

  ///Fetch api validToken
  Future<dynamic> validateToken() async {
    return await Api.validateToken();
  }

  ///Fetch api change Password
  Future<dynamic> changePassword({password}) async {
    final params = {"password": password};
    return await Api.changePassword(params);
  }

  ///Fetch api forgot Password
  Future<dynamic> forgotPassword({email}) async {
    final params = {"email": email};
    return await Api.forgotPassword(params);
  }

  ///Fetch api register account
  Future<dynamic> register({username, password, email}) async {
    final params = {"username": username, "password": password, "email": email};
    return await Api.register(params);
  }

  ///Fetch api forgot Password
  Future<dynamic> changeProfile({name, email, website, information}) async {
    final params = {
      "name": name,
      "email": email,
      "url": website,
      "description": information,
    };
    return await Api.changeProfile(params);
  }

  ///Save Storage
  Future<dynamic> saveUser({UserModel user}) async {
    return await UtilPreferences.setString(
      Preferences.user,
      jsonEncode(user.toJson()),
    );
  }

  ///Get from Storage
  dynamic getUser() {
    return UtilPreferences.getString(Preferences.user);
  }

  ///Delete Storage
  Future<dynamic> deleteUser() async {
    return await UtilPreferences.remove(Preferences.user);
  }
}
