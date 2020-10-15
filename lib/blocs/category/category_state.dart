import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState {}

class InitialCategoryState extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<CategoryModel> category;
  CategoryLoadSuccess({this.category});
}

class CategoryLoadFail extends CategoryState {}
