import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class ResultList extends StatefulWidget {
  final String query;
  ResultList({
    Key key,
    this.query,
  }) : super(key: key);

  @override
  _ResultListState createState() {
    return _ResultListState();
  }
}

class _ResultListState extends State<ResultList> {
  @override
  void initState() {
    super.initState();
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) async {
    AppBloc.searchBloc.add(OnSaveHistory(item: item));
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (widget.query.isNotEmpty) {
            if (state is SearchSuccess) {
              if (state.list.isEmpty) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.sentiment_satisfied),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          Translate.of(context).translate(
                            'search_is_empty',
                          ),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                ),
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  final item = state.list[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: AppProductItem(
                      onPressed: _onProductDetail,
                      item: item,
                      type: ProductViewType.small,
                    ),
                  );
                },
              );
            }
            if (state is SearchLoading) {
              return Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                ),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
