import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilterState {}

class InitialFilterState extends FilterState {}

class FetchingFilter extends FilterState {}

class FilterSuccess extends FilterState {}

class FilterFail extends FilterState {
  final String code;
  FilterFail({this.code});
}
