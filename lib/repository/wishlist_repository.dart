import 'package:listar/api/api.dart';

class WishListRepository {
  ///Fetch api loadWishList
  Future<dynamic> loadWishList(Map<String, dynamic> params) async {
    return await Api.getWishList(params);
  }

  ///Fetch api add wishList
  Future<dynamic> addWishList(Map<String, dynamic> params) async {
    return await Api.addWishList(params);
  }

  ///Fetch api add wishList
  Future<dynamic> removeWishList(Map<String, dynamic> params) async {
    return await Api.removeWishList(params);
  }

  ///Fetch api clear wishList
  Future<dynamic> clearWishList() async {
    return await Api.clearWishList(null);
  }
}
