import 'dart:async';

import 'package:listar/api/http_manager.dart';
import 'package:listar/models/model.dart';

class Api {
  ///URL API
  static const String AUTH_LOGIN = "/jwt-auth/v1/token";
  static const String AUTH_VALIDATE = "/jwt-auth/v1/token/validate";
  static const String REGISTER = "/listar/v1/auth/register";
  static const String FORGOT_PASSWORD = "/listar/v1/auth/reset_password";
  static const String CHANGE_PASSWORD = "/wp/v2/users/me";
  static const String CHANGE_PROFILE = "/wp/v2/users/me";
  static const String GET_SETTING = "/listar/v1/setting/init";
  static const String GET_HOME = "/listar/v1/home/init";
  static const String GET_CATEGORY = "/listar/v1/category/list";
  static const String GET_WISHLIST = "/listar/v1/wishlist/list";
  static const String SAVE_WISHLIST = "/listar/v1/wishlist/save";
  static const String DELETE_WISHLIST = "/listar/v1/wishlist/remove";
  static const String CLEAR_WISHLIST = "/listar/v1/wishlist/reset";
  static const String GET_LIST_PRODUCT = "/listar/v1/place/list";
  static const String GET_COMMENT = "/listar/v1/comments";
  static const String SAVE_COMMENT = "/wp/v2/comments";
  static const String GET_PRODUCT_DETAIL = "/listar/v1/place/view";
  static const String GET_AREA = "/listar/v1/location/list";

  ///Login api
  static Future<dynamic> login(params) async {
    final result = await httpManager.post(url: AUTH_LOGIN, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Validate token valid
  static Future<dynamic> validateToken() async {
    Map<String, dynamic> result = await httpManager.post(url: AUTH_VALIDATE);
    result['success'] = result['code'] == 'jwt_auth_valid_token';
    result['code'] = result['code'];
    return ResultApiModel.fromJson(result);
  }

  ///Forgot password
  static Future<dynamic> forgotPassword(params) async {
    final result = await httpManager.post(url: FORGOT_PASSWORD, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Register account
  static Future<dynamic> register(params) async {
    final result = await httpManager.post(url: REGISTER, data: params);
    Map<String, dynamic> convertResponse = {
      "success": result['code'] == 200,
      "code": result['code'],
      "data": result
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Change Profile
  static Future<dynamic> changeProfile(params) async {
    final result = await httpManager.post(url: CHANGE_PROFILE, data: params);
    Map<String, dynamic> convertResponse = {
      "success": result['code'] == null,
      "code": result['code'],
      "data": result
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///change password
  static Future<dynamic> changePassword(params) async {
    final result = await httpManager.post(url: CHANGE_PASSWORD, data: params);
    Map<String, dynamic> convertResponse = {
      "success": result['code'] == null,
      "code": result['code'],
      "data": result
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Get Setting
  static Future<dynamic> getSetting() async {
    final result = await httpManager.get(url: GET_SETTING);
    return ResultApiModel.fromJson(result);
  }

  ///Get Area
  static Future<dynamic> getArea(params) async {
    final result = await httpManager.get(url: GET_AREA, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  static Future<dynamic> getCategory() async {
    final result = await httpManager.get(url: GET_CATEGORY);
    return ResultApiModel.fromJson(result);
  }

  ///Get Home
  static Future<dynamic> getHome() async {
    final result = await httpManager.get(url: GET_HOME);
    return ResultApiModel.fromJson(result);
  }

  ///Get ProductDetail
  static Future<dynamic> getProductDetail(params) async {
    final result = await httpManager.get(
      url: GET_PRODUCT_DETAIL,
      params: params,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Wish List
  static Future<dynamic> getWishList(params) async {
    final result = await httpManager.get(url: GET_WISHLIST, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Save Wish List
  static Future<dynamic> addWishList(params) async {
    final result = await httpManager.post(url: SAVE_WISHLIST, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Remove Wish List
  static Future<dynamic> removeWishList(params) async {
    final result = await httpManager.post(url: DELETE_WISHLIST, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  static Future<dynamic> clearWishList(params) async {
    final result = await httpManager.post(url: CLEAR_WISHLIST, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Product List
  static Future<dynamic> getProductList(params) async {
    final result = await httpManager.get(url: GET_LIST_PRODUCT, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Get Review
  static Future<dynamic> getReview(params) async {
    final result = await httpManager.get(url: GET_COMMENT, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Save Review
  static Future<dynamic> saveReview(params) async {
    final result = await httpManager.post(url: SAVE_COMMENT, data: params);
    Map<String, dynamic> convertResponse = {
      "success": result['code'] == null,
      "code": result['code'],
      "data": result
    };
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Singleton factory
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();
}
