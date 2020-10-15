import 'package:meta/meta.dart';

@immutable
abstract class CategoryEvent {}

class OnLoadCategory extends CategoryEvent {}
