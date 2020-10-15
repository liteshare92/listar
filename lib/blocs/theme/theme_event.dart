import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ThemeEvent {}

class OnChangeTheme extends ThemeEvent {
  final ThemeModel theme;
  final String font;
  final DarkOption darkOption;

  OnChangeTheme({
    this.theme,
    this.font,
    this.darkOption,
  });
}
