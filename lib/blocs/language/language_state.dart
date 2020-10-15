import 'package:meta/meta.dart';

@immutable
abstract class LanguageState {}

class InitialLanguageState extends LanguageState {}

class LanguageUpdating extends LanguageState {}

class LanguageUpdated extends LanguageState {}
