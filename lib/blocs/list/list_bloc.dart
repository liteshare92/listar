import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/list_repository.dart';

import 'bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(InitialListState());
  final ListRepository listRepository = ListRepository();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    ///Load List
    if (event is OnLoadList) {
      yield ListProductLoading();
      Map<String, dynamic> params = {
        "page": 1,
        "per_page": ListSetting.perPage,
      };
      if (event.category != null) {
        params['category'] = event.category.map((item) {
          return item.id;
        }).toList();
      }
      if (event.feature != null) {
        params['feature'] = event.feature.map((item) {
          return item.id;
        }).toList();
      }
      if (event.location != null) {
        params['location'] = event.location.id;
      }
      if (event.priceMin != null) {
        params['price_min'] = event.priceMin.toInt();
      }
      if (event.priceMax != null) {
        params['price_max'] = event.priceMax.toInt();
      }
      if (event.color != null) {
        params['color'] = event.color;
      }
      if (event.sort != null) {
        params['orderby'] = event.sort.value;
        params['order'] = event.sort.field;
      }

      ///Fetch API
      final ResultApiModel response = await listRepository.loadList(params);
      if (response.success) {
        final Iterable convertList = response.data ?? [];

        final list = convertList.map((item) {
          return ProductModel.fromJson(item);
        }).toList();

        yield ListLoadSuccess(
          list: list,
          pagination: PaginationModel.fromJson(response?.pagination),
        );
      } else {
        yield ListLoadFail();
      }
    }

    ///Load More
    if (event is OnLoadMoreList) {
      Map<String, dynamic> params = {
        "page": event.page,
        "per_page": ListSetting.perPage,
      };
      if (event.category != null) {
        params['category'] = event.category.map((item) {
          return item.id;
        }).toList();
      }
      if (event.feature != null) {
        params['feature'] = event.feature.map((item) {
          return item.id;
        }).toList();
      }
      if (event.location != null) {
        params['location'] = event.location.id;
      }
      if (event.priceMin != null) {
        params['price_min'] = event.priceMin.toInt();
      }
      if (event.priceMax != null) {
        params['price_max'] = event.priceMax.toInt();
      }
      if (event.color != null) {
        params['color'] = event.color;
      }
      if (event.sort != null) {
        params['orderby'] = event.sort.value;
        params['order'] = event.sort.field;
      }

      ///Fetch API
      final ResultApiModel response = await listRepository.loadList(params);
      final Iterable refactorWishList = response?.data ?? [];
      if (response.success) {
        final listWishList = refactorWishList.map((item) {
          return ProductModel.fromJson(item);
        }).toList();

        event.list.addAll(listWishList);
      }

      ///Sync UI
      yield ListLoadSuccess(
        list: event.list,
        pagination: PaginationModel.fromJson(response?.pagination),
      );
    }

    ///WishList Update
    if (event is OnWishListChange) {
      ///Sync UI
      yield ListLoadSuccess(
        list: event.list.map((ProductModel item) {
          if (event.id == item.id) {
            item.favorite = !item.favorite;
          }
          return item;
        }).toList(),
        pagination: event.pagination,
      );
    }
  }
}
