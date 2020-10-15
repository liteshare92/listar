import 'package:listar/api/api.dart';

class ListRepository {
  ///Fetch api load setting
  Future<dynamic> getSetting() async {
    return await Api.getSetting();
  }

  ///Fetch api load setting
  Future<dynamic> getArea(params) async {
    return await Api.getArea(params);
  }

  ///Fetch api load list
  Future<dynamic> loadList(params) async {
    return await Api.getProductList(params);
  }
}
