import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/screens/home/home_category_item.dart';
import 'package:listar/utils/utils.dart';

class HomeCategoryList extends StatelessWidget {
  final Function(CategoryModel) onPress;
  final VoidCallback onOpenList;

  HomeCategoryList({
    Key key,
    this.onPress,
    this.onOpenList,
  }) : super(key: key);

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadSuccess) {
          return Wrap(
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: state.category.map(
              (item) {
                return HomeCategoryItem(
                  item: item,
                  onPressed: onPress,
                );
              },
            ).toList(),
          );
        }

        return Wrap(
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: List.generate(8, (index) => index).map(
            (item) {
              return HomeCategoryItem();
            },
          ).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate('explore_product'),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: onOpenList,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: Text(
                          Translate.of(context).translate('view_list'),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 24),
                    child: _buildContent(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
