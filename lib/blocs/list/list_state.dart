import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ListState {}

class InitialListState extends ListState {}

class ListProductLoading extends ListState {}

class ListLoadSuccess extends ListState {
  final List<ProductModel> list;
  final PaginationModel pagination;
  ListLoadSuccess({this.list, this.pagination});
}

class ListLoadFail extends ListState {}
