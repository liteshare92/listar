import 'package:meta/meta.dart';

@immutable
abstract class ProductDetailEvent {}

class OnLoadProduct extends ProductDetailEvent {
  final int id;
  OnLoadProduct({this.id});
}
