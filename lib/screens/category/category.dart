import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class Category extends StatefulWidget {
  Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() {
    return _CategoryState();
  }
}

class _CategoryState extends State<Category> {
  final _textController = TextEditingController();

  String _keyword = '';
  CategoryView _type = CategoryView.full;

  @override
  void initState() {
    AppBloc.categoryBloc.add(OnLoadCategory());
    super.initState();
  }

  ///On refresh list
  Future<void> _onRefresh() async {
    AppBloc.categoryBloc.add(OnLoadCategory());
  }

  ///On clear search
  Future<void> _onClearTapped() async {
    await Future.delayed(Duration(milliseconds: 100));
    _textController.text = '';
    _onSearch('');
  }

  ///On change mode view
  void _onChangeModeView() {
    switch (_type) {
      case CategoryView.full:
        setState(() {
          _type = CategoryView.icon;
        });
        break;
      case CategoryView.icon:
        setState(() {
          _type = CategoryView.full;
        });
        break;
      default:
        break;
    }
  }

  ///On navigate list product
  void _onProductList(CategoryModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }

  ///On Search Category
  void _onSearch(String text) {
    setState(() {
      _keyword = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('category')),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _type == CategoryView.icon
                  ? Icons.view_headline
                  : Icons.view_agenda,
            ),
            onPressed: _onChangeModeView,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: AppTextInput(
                hintText: Translate.of(context).translate('search'),
                onTapIcon: _onClearTapped,
                icon: Icon(Icons.clear),
                controller: _textController,
                onSubmitted: _onSearch,
                onChanged: _onSearch,
              ),
            ),
            Expanded(
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  ///Loading
                  Widget content = ListView.builder(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    itemCount: List.generate(8, (index) => index).length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: AppCategory(type: _type),
                      );
                    },
                  );

                  ///Success
                  if (state is CategoryLoadSuccess) {
                    List<CategoryModel> category = state.category;
                    if (_keyword.isNotEmpty) {
                      category = category.where(((item) {
                        return item.title
                            .toUpperCase()
                            .contains(_keyword.toUpperCase());
                      })).toList();
                    }

                    ///Empty
                    if (category.isEmpty) {
                      content = Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.sentiment_satisfied),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                Translate.of(context)
                                    .translate('category_not_found'),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ///List data
                      content = ListView.builder(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          final item = category[index];
                          final borderBottom = index != category.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: AppCategory(
                              type: _type,
                              item: item,
                              bottomLine: borderBottom,
                              onPressed: (item) {
                                _onProductList(item);
                              },
                            ),
                          );
                        },
                      );
                    }
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: content,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
