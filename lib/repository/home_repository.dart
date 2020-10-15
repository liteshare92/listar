import 'package:listar/api/api.dart';

class HomeRepository {
  ///Fetch api loadData
  Future<dynamic> loadData() async {
    return await Api.getHome();
  }
}
