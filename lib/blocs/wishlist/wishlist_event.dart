import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WishListEvent {}

class OnLoadWishList extends WishListEvent {
  OnLoadWishList();
}

class OnLoadMoreWishList extends WishListEvent {
  final int page;
  final List<ProductModel> wishList;
  OnLoadMoreWishList({this.page, this.wishList});
}

class OnAddWishList extends WishListEvent {
  final int id;
  OnAddWishList({this.id});
}

class OnRemoveWishList extends WishListEvent {
  final int id;
  final int index;
  final List<ProductModel> wishList;
  OnRemoveWishList({this.id, this.index, this.wishList});
}

class OnClearWishList extends WishListEvent {
  final List<ProductModel> wishList;
  OnClearWishList({this.wishList});
}
