import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/bloc.dart';

class AppBloc {
  static final applicationBloc = ApplicationBloc();
  static final languageBloc = LanguageBloc();
  static final themeBloc = ThemeBloc();
  static final listBloc = ListBloc();
  static final passwordBloc = PasswordBloc();
  static final authBloc = AuthBloc();
  static final loginBloc = LoginBloc();
  static final productDetailBloc = ProductDetailBloc();
  static final categoryBloc = CategoryBloc();
  static final homeBloc = HomeBloc();
  static final wishListBloc = WishListBloc();
  static final editProfileBloc = EditProfileBloc();
  static final filterBloc = FilterBloc();
  static final reviewBloc = ReviewBloc();
  static final searchBloc = SearchBloc();
  static final registerBloc = RegisterBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationBloc>(
      create: (context) => applicationBloc,
    ),
    BlocProvider<LanguageBloc>(
      create: (context) => languageBloc,
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => themeBloc,
    ),
    BlocProvider<AuthBloc>(
      create: (context) => authBloc,
    ),
    BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
    ),
    BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
    ),
    BlocProvider<CategoryBloc>(
      create: (context) => categoryBloc,
    ),
    BlocProvider<WishListBloc>(
      create: (context) => wishListBloc,
    ),
    BlocProvider<ListBloc>(
      create: (context) => listBloc,
    ),
    BlocProvider<ProductDetailBloc>(
      create: (context) => productDetailBloc,
    ),
    BlocProvider<PasswordBloc>(
      create: (context) => passwordBloc,
    ),
    BlocProvider<EditProfileBloc>(
      create: (context) => editProfileBloc,
    ),
    BlocProvider<FilterBloc>(
      create: (context) => filterBloc,
    ),
    BlocProvider<ReviewBloc>(
      create: (context) => reviewBloc,
    ),
    BlocProvider<SearchBloc>(
      create: (context) => searchBloc,
    ),
    BlocProvider<RegisterBloc>(
      create: (context) => registerBloc,
    ),
  ];

  static void dispose() {
    applicationBloc.close();
    languageBloc.close();
    themeBloc.close();
    categoryBloc.close();
    homeBloc.close();
    wishListBloc.close();
    listBloc.close();
    productDetailBloc.close();
    passwordBloc.close();
    authBloc.close();
    loginBloc.close();
    editProfileBloc.close();
    filterBloc.close();
    reviewBloc.close();
    searchBloc.close();
    registerBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
