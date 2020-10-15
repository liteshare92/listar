import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductDetailState {}

class InitialProductDetailState extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  final UserModel author;
  final ProductModel product;
  ProductDetailSuccess({this.product, this.author});
}

class ProductDetailFail extends ProductDetailState {
  final String code;
  ProductDetailFail({this.code});
}
