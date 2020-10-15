import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {}

class OnLoadingHome extends HomeEvent {}
