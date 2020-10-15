import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState {}

class InitialHomeState extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<String> banner;
  final List<CategoryModel> category;
  final List<CategoryModel> location;
  final List<ProductModel> recent;

  HomeSuccess({this.banner, this.category, this.location, this.recent});
}

class HomeLoadFail extends HomeState {}
