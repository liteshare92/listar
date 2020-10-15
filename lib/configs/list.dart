import 'package:flutter/material.dart';
import 'package:listar/models/model.dart';
import 'package:listar/widgets/widget.dart';

class ListSetting {
  static List<CategoryModel> category = [];
  static List<CategoryModel> features = [];
  static List<CategoryModel> locations = [];
  static List<SortModel> sort = [];
  static int perPage = 20;
  static ProductViewType modeView = ProductViewType.list;
  static num priceMin = 0;
  static num priceMax = 100;
  static List<String> color = [];
  static String unit = 'USD';
  static TimeOfDay startHour = TimeOfDay(hour: 8, minute: 0);
  static TimeOfDay endHour = TimeOfDay(hour: 15, minute: 0);

  ///Singleton factory
  static final ListSetting _instance = ListSetting._internal();

  factory ListSetting() {
    return _instance;
  }

  ListSetting._internal();
}
