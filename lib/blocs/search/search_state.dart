import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchState {}

class InitialSearchState extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ProductModel> list;
  SearchSuccess({this.list});
}

class SearchFail extends SearchState {
  final String code;
  SearchFail({this.code});
}

class LoadingHistorySuccess extends SearchState {
  final List<ProductModel> list;
  LoadingHistorySuccess({this.list});
}

class SaveHistorySuccess extends SearchState {}

class RemoveHistorySuccess extends SearchState {}
