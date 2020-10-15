import 'package:meta/meta.dart';

@immutable
abstract class FilterEvent {}

class OnLoadFilter extends FilterEvent {}
