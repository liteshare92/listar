import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';
import 'package:listar/widgets/widget.dart';

import 'bloc.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(InitialFilterState());
  final ListRepository listRepository = ListRepository();

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is OnLoadFilter) {
      yield FetchingFilter();

      ///Fetch change password
      final ResultApiModel result = await listRepository.getSetting();

      ///Case success
      if (result.success) {
        final Iterable refactorCategory = result?.data['categories'] ?? [];
        final Iterable refactorFeatures = result?.data['features'] ?? [];
        final Iterable refactorLocation = result?.data['locations'] ?? [];
        final Iterable refactorSort = result?.data['place_sort_option'] ?? [];
        final listCategory = refactorCategory.map((item) {
          return CategoryModel.fromJson(item);
        }).toList();
        final listFeatures = refactorFeatures.map((item) {
          return CategoryModel.fromJson(item);
        }).toList();
        final listLocation = refactorLocation.map((item) {
          return CategoryModel.fromJson(item);
        }).toList();
        final listSort = refactorSort.map((item) {
          return SortModel.fromJson(item);
        }).toList();

        if (result?.data['settings'] != null &&
            result?.data['settings']['price_min'] != null) {
          ListSetting.priceMin = result?.data['settings']['price_min'];
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['price_min'] != null) {
          ListSetting.priceMax = result?.data['settings']['price_max'];
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['color_option'] != null) {
          ListSetting.color =
              result?.data['settings']['color_option'].cast<String>();
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['unit_price'] != null) {
          ListSetting.unit = result?.data['settings']['unit_price'];
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['time_min'] != null) {
          List<String> split = result?.data['settings']['time_min'].split(':');
          ListSetting.startHour = TimeOfDay(
            hour: int.tryParse(split[0]) ?? 0,
            minute: int.tryParse(split[1]) ?? 0,
          );
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['time_max'] != null) {
          List<String> split = result?.data['settings']['time_max'].split(':');
          ListSetting.endHour = TimeOfDay(
            hour: int.tryParse(split[0]) ?? 0,
            minute: int.tryParse(split[1]) ?? 0,
          );
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['per_page'] != null) {
          ListSetting.perPage = result?.data['settings']['per_page'];
        }
        if (result?.data['settings'] != null &&
            result?.data['settings']['list_mode'] != null) {
          final String view = result?.data['settings']['list_mode'];
          if (view == 'list') {
            ListSetting.modeView = ProductViewType.list;
          }
          if (view == 'gird') {
            ListSetting.modeView = ProductViewType.gird;
          }
          if (view == 'list') {
            ListSetting.modeView = ProductViewType.block;
          }
        }

        ListSetting.category = listCategory;
        ListSetting.features = listFeatures;
        ListSetting.locations = listLocation;
        ListSetting.sort = listSort;

        ///Notify loading to UI
        yield FilterSuccess();
      } else {
        ///Notify loading to UI
        yield FilterFail(code: result.code);
      }
    }
  }
}
