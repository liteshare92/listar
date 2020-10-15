import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

import 'bloc.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(InitialProductDetailState());

  final ProductRepository productRepository = ProductRepository();

  @override
  Stream<ProductDetailState> mapEventToState(ProductDetailEvent event) async* {
    if (event is OnLoadProduct) {
      yield ProductDetailLoading();

      ///Fetch API
      final ResultApiModel response = await productRepository.loadDetail(
        {"id": event.id},
      );
      if (response.success) {
        yield ProductDetailSuccess(
          product: ProductModel.fromJson(response.data),
          author: UserModel.fromJson(response.data['author']),
        );
      } else {
        yield ProductDetailFail(code: response.code);
      }
    }
  }
}
