import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

import 'bloc.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  WishListBloc() : super(InitialWishListState());
  final WishListRepository wishListRepository = WishListRepository();

  @override
  Stream<WishListState> mapEventToState(WishListEvent event) async* {
    if (event is OnLoadWishList) {
      yield WishListLoading();

      ///Fetch API
      final ResultApiModel response = await wishListRepository.loadWishList(
        {"page": 1, "per_page": ListSetting.perPage},
      );
      if (response.success) {
        final Iterable refactorWishList = response?.data ?? [];
        final listWishList = refactorWishList.map((item) {
          return ProductModel.fromJson(item);
        }).toList();

        ///Sync UI
        yield WishListSuccess(
          wishList: listWishList,
          pagination: PaginationModel.fromJson(response?.pagination),
        );
      } else {
        yield WishListLoadFail(code: response.code);
      }
    }

    if (event is OnLoadMoreWishList) {
      ///Fetch API
      final ResultApiModel response = await wishListRepository.loadWishList({
        "page": event.page,
        "per_page": ListSetting.perPage,
      });
      final Iterable refactorWishList = response?.data ?? [];
      final listWishList = refactorWishList.map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      event.wishList.addAll(listWishList);

      ///Sync UI
      yield WishListSuccess(
        wishList: event.wishList,
        pagination: PaginationModel.fromJson(response?.pagination),
      );
    }

    if (event is OnAddWishList) {
      ///Fetch API
      final ResultApiModel response = await wishListRepository.addWishList(
        {"post_id": event.id},
      );
      if (response.success) {
        ///Sync UI
        yield WishListSaveSuccess(id: event.id);
      } else {
        yield WishListSaveFail(code: response.code);
      }
    }

    if (event is OnRemoveWishList) {
      ///Fetch API
      final ResultApiModel response = await wishListRepository.removeWishList(
        {"post_id": event.id},
      );
      if (response.success) {
        ///Sync UI
        yield WishListRemoveSuccess(id: event.id);
      } else {
        yield WishListRemoveFail(code: response.code);
      }
    }

    if (event is OnClearWishList) {
      yield WishListLoading();
      final ResultApiModel response = await wishListRepository.clearWishList();
      if (response.success) {
        ///Sync UI
        yield WishListRemoveSuccess();
      } else {
        yield WishListRemoveFail(code: response.code);
      }
    }
  }
}
