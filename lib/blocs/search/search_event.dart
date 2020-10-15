import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent {}

class OnSearch extends SearchEvent {
  final String keyword;
  OnSearch({this.keyword});
}

class OnLoadHistory extends SearchEvent {}

class OnSaveHistory extends SearchEvent {
  final ProductModel item;
  OnSaveHistory({this.item});
}

class OnClearHistory extends SearchEvent {
  final ProductModel item;
  OnClearHistory({this.item});
}
