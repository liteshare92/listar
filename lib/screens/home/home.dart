import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/screens/home/home_category_item.dart';
import 'package:listar/screens/home/home_category_list.dart';
import 'package:listar/screens/home/home_sliver_app_bar.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    AppBloc.homeBloc.add(OnLoadingHome());
    super.initState();
  }

  ///Refresh
  Future<void> _onRefresh() async {
    AppBloc.homeBloc.add(OnLoadingHome());
  }

  ///On select category
  void _onTapService(CategoryModel item) {
    Navigator.pushNamed(context, Routes.listProduct, arguments: item);
  }

  ///On Open More
  void _onOpenMore(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return HomeCategoryList(
          onOpenList: () async {
            Navigator.pushNamed(context, Routes.category);
          },
          onPress: (item) async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 200));
            Navigator.pushNamed(context, Routes.listProduct, arguments: item);
          },
        );
      },
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///Build category UI
  Widget _buildCategory(List<CategoryModel> category) {
    if (category != null) {
      List<CategoryModel> listBuild = category;
      final more = CategoryModel.fromJson({
        "term_id": 9999,
        "name": Translate.of(context).translate("more"),
        "icon": "fas fa-ellipsis-h",
        "color": "#ff8a65",
      });

      if (category.length >= 7) {
        listBuild = category.take(7).toList();
        listBuild.add(more);
      }

      return Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: listBuild.map(
          (item) {
            return HomeCategoryItem(
              item: item,
              onPressed: (item) {
                if (item.id == 9999) {
                  _onOpenMore(context);
                } else {
                  _onTapService(item);
                }
              },
            );
          },
        ).toList(),
      );
    }

    return Wrap(
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(8, (index) => index).map(
        (item) {
          return HomeCategoryItem();
        },
      ).toList(),
    );
  }

  ///Build popular UI
  Widget _buildLocation(List<CategoryModel> location) {
    if (location == null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 15),
            child: AppCategory(
              type: CategoryView.cardLarge,
            ),
          );
        },
        itemCount: List.generate(8, (index) => index).length,
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
      itemBuilder: (context, index) {
        final item = location[index];
        return Padding(
          padding: EdgeInsets.only(left: 15),
          child: SizedBox(
            width: 135,
            height: 160,
            child: AppCategory(
              item: item,
              type: CategoryView.cardLarge,
              onPressed: (item) {
                Navigator.pushNamed(
                  context,
                  Routes.listProduct,
                  arguments: item,
                );
              },
            ),
          ),
        );
      },
      itemCount: location.length,
    );
  }

  ///Build list recent
  Widget _buildRecent(List<ProductModel> recent) {
    if (recent == null) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: AppProductItem(type: ProductViewType.small),
          );
        },
        itemCount: 8,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = recent[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: AppProductItem(
            onPressed: _onProductDetail,
            item: item,
            type: ProductViewType.small,
          ),
        );
      },
      itemCount: recent.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoadFail) {
            final snackBar = SnackBar(
              content: Text(
                Translate.of(context).translate('cannot_connect_to_server'),
              ),
              action: SnackBarAction(
                label: Translate.of(context).translate('reload'),
                onPressed: () {
                  AppBloc.homeBloc.add(OnLoadingHome());
                },
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            List<String> banner;
            List<CategoryModel> category;
            List<CategoryModel> location;
            List<ProductModel> recent;

            if (state is HomeSuccess) {
              banner = state.banner;
              category = state.category;
              location = state.location;
              recent = state.recent;
            }

            return CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverPersistentHeader(
                  delegate: AppBarHomeSliver(
                    expandedHeight: 250,
                    banners: banner,
                  ),
                  pinned: true,
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: _onRefresh,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SafeArea(
                      top: false,
                      bottom: false,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 15,
                              left: 10,
                              right: 10,
                            ),
                            child: _buildCategory(category),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      Translate.of(context).translate(
                                        'popular_location',
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 3)),
                                    Text(
                                      Translate.of(context).translate(
                                        'let_find_interesting',
                                      ),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 195,
                            child: _buildLocation(location),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 15,
                            ),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      Translate.of(context)
                                          .translate('recent_location'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                    ),
                                    Text(
                                      Translate.of(context)
                                          .translate('what_happen'),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: _buildRecent(recent),
                          ),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
