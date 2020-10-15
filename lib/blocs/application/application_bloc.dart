import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final deviceInfoPlugin = DeviceInfoPlugin();

  ApplicationBloc() : super(InitialApplicationState());

  @override
  Stream<ApplicationState> mapEventToState(event) async* {
    if (event is OnSetupApplication) {
      ///Pending loading to UI
      yield ApplicationWaiting();

      ///Load Filter config
      AppBloc.filterBloc.add(OnLoadFilter());

      ///Setup SharedPreferences
      Application.preferences = await SharedPreferences.getInstance();

      ///Read/Save Device Information
      DeviceModel deviceModel;
      try {
        if (Platform.isAndroid) {
          final android = await deviceInfoPlugin.androidInfo;
          deviceModel = DeviceModel(
            uuid: android.androidId,
            model: "Android",
            version: android.version.sdkInt.toString(),
            type: android.model,
          );
        } else if (Platform.isIOS) {
          final IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
          deviceModel = DeviceModel(
            uuid: ios.identifierForVendor,
            name: ios.name,
            model: ios.systemName,
            version: ios.systemVersion,
            type: ios.utsname.machine,
          );
        }
      } catch (e) {}
      Application.device = deviceModel;

      ///Get old Theme & Font & Language
      final oldTheme = UtilPreferences.getString(Preferences.theme);
      final oldFont = UtilPreferences.getString(Preferences.font);
      final oldLanguage = UtilPreferences.getString(Preferences.language);
      final oldDarkOption = UtilPreferences.getString(Preferences.darkOption);

      ThemeModel theme;
      String font;
      DarkOption darkOption;

      ///Setup Language
      if (oldLanguage != null) {
        AppBloc.languageBloc.add(
          OnChangeLanguage(Locale(oldLanguage)),
        );
      }

      ///Find font support available
      final fontAvailable = AppTheme.fontSupport.where((item) {
        return item == oldFont;
      }).toList();

      ///Find theme support available
      final themeAvailable = AppTheme.themeSupport.where((item) {
        return item.name == oldTheme;
      }).toList();

      ///Check theme and font available
      if (fontAvailable.isNotEmpty) {
        font = fontAvailable[0];
      }

      if (themeAvailable.isNotEmpty) {
        theme = themeAvailable[0];
      }

      ///check old dark option
      if (oldDarkOption != null) {
        switch (oldDarkOption) {
          case DARK_ALWAYS_OFF:
            darkOption = DarkOption.alwaysOff;
            break;
          case DARK_ALWAYS_ON:
            darkOption = DarkOption.alwaysOn;
            break;
          default:
            darkOption = DarkOption.dynamic;
        }
      }

      ///Setup Theme & Font with dark Option
      AppBloc.themeBloc.add(
        OnChangeTheme(
          theme: theme ?? AppTheme.currentTheme,
          font: font ?? AppTheme.currentFont,
          darkOption: darkOption ?? AppTheme.darkThemeOption,
        ),
      );

      ///Authentication begin check
      AppBloc.authBloc.add(OnAuthCheck());

      ///First or After upgrade version show intro preview app
      final hasReview = UtilPreferences.containsKey(
        '${Preferences.reviewIntro}.${Application.version}',
      );
      if (hasReview) {
        ///Become app
        yield ApplicationSetupCompleted();
      } else {
        ///Pending preview intro
        yield ApplicationIntroView();
      }
    }

    ///Event Completed IntroView
    if (event is OnCompletedIntro) {
      await UtilPreferences.setBool(
        '${Preferences.reviewIntro}.${Application.version}',
        true,
      );

      ///Become app
      yield ApplicationSetupCompleted();
    }
  }
}
