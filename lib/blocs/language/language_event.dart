import 'package:flutter/cupertino.dart';

abstract class LanguageEvent {}

class OnChangeLanguage extends LanguageEvent {
  final Locale locale;

  OnChangeLanguage(this.locale);
}
