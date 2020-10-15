import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';

import 'search_result_list.dart';
import 'search_suggest_list.dart';

class SearchHistory extends StatefulWidget {
  SearchHistory({Key key}) : super(key: key);

  @override
  _SearchHistoryState createState() {
    return _SearchHistoryState();
  }
}

class _SearchHistoryState extends State<SearchHistory> {
  SearchHistorySearchDelegate _delegate = SearchHistorySearchDelegate();

  @override
  void initState() {
    AppBloc.searchBloc.add(OnLoadHistory());
    super.initState();
  }

  Future<ProductModel> _onSearch() async {
    final ProductModel selected = await showSearch(
      context: context,
      delegate: _delegate,
    );
    return selected;
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) async {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _delegate?.transitionAnimation,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(Translate.of(context).translate('search_title')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is RemoveHistorySuccess || state is SaveHistorySuccess) {
              AppBloc.searchBloc.add(OnLoadHistory());
            }
          },
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is LoadingHistorySuccess) {
                return ListView(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                Translate.of(context)
                                    .translate('search_history')
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  AppBloc.searchBloc.add(OnClearHistory());
                                },
                                child: Text(
                                  Translate.of(context).translate('clear'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 10,
                            children: state.list.map((item) {
                              return InputChip(
                                onPressed: () {
                                  _onProductDetail(item);
                                },
                                label: Text(item.title),
                                onDeleted: () {
                                  AppBloc.searchBloc
                                      .add(OnClearHistory(item: item));
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class SearchHistorySearchDelegate extends SearchDelegate<ProductModel> {
  SearchHistorySearchDelegate();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    if (isDark) {
      return theme;
    }

    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        AppBloc.searchBloc.add(OnLoadHistory());
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionList(query: query);
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultList(query: query);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
    return null;
  }
}
