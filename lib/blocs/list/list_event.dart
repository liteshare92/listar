import 'package:listar/models/model.dart';

abstract class ListEvent {}

class OnLoadList extends ListEvent {
  final List<CategoryModel> category;
  final List<CategoryModel> feature;
  final CategoryModel location;
  final double priceMin;
  final double priceMax;
  final String color;
  final SortModel sort;

  OnLoadList({
    this.category,
    this.feature,
    this.location,
    this.priceMin,
    this.priceMax,
    this.color,
    this.sort,
  });
}

class OnLoadMoreList extends ListEvent {
  final List<CategoryModel> category;
  final List<CategoryModel> feature;
  final CategoryModel location;
  final int page;
  final List<ProductModel> list;
  final double priceMin;
  final double priceMax;
  final String color;
  final SortModel sort;

  OnLoadMoreList({
    this.category,
    this.feature,
    this.location,
    this.page,
    this.list,
    this.priceMin,
    this.priceMax,
    this.color,
    this.sort,
  });
}

class OnWishListChange extends ListEvent {
  final List<ProductModel> list;
  final int id;
  final PaginationModel pagination;
  OnWishListChange({
    this.id,
    this.list,
    this.pagination,
  });
}
