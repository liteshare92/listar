import 'package:listar/api/api.dart';

class CategoryRepository {
  ///Fetch api loadCategory
  Future<dynamic> loadCategory() async {
    return await Api.getCategory();
  }
}
