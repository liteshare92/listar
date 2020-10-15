import 'package:listar/api/api.dart';

class ProductRepository {
  ///Fetch api loadDetail
  Future<dynamic> loadDetail(params) async {
    return await Api.getProductDetail(params);
  }

  ///Fetch api getReview
  Future<dynamic> getReview(params) async {
    return await Api.getReview(params);
  }

  ///Fetch save review
  Future<dynamic> saveReview(params) async {
    return await Api.saveReview(params);
  }
}
