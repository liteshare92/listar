import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';
import 'package:share/share.dart';

class WishList extends StatefulWidget {
  WishList({Key key}) : super(key: key);

  @override
  _WishListState createState() {
    return _WishListState();
  }
}

class _WishListState extends State<WishList> {
  final _scrollController = ScrollController();
  final _endReachedThreshold = 500;

  List<ProductModel> _list = [];
  int _page = 1;
  bool _loadingMore = false;
  bool _canLoadMore = true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  ///Load More
  void _onLoadMore(List<ProductModel> wishList) {
    setState(() {
      _loadingMore = true;
    });
    AppBloc.wishListBloc.add(
      OnLoadMoreWishList(page: _page + 1, wishList: wishList),
    );
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    if (!_loadingMore &&
        _canLoadMore &&
        AppBloc.wishListBloc.state is WishListSuccess) {
      _onLoadMore(_list);
    }
  }

  ///On refresh
  Future<void> _onRefresh() async {
    AppBloc.wishListBloc.add(OnLoadWishList());
  }

  ///Clear all wishlist
  void _clearWishList() {
    AppBloc.wishListBloc.add(OnClearWishList());
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WishListBloc, WishListState>(
      listener: (context, state) {
        if (state is WishListSuccess) {
          setState(() {
            _list = state.wishList;
            _canLoadMore = state.pagination.page < state.pagination.maxPage;
            _page = state.pagination.page;
            _loadingMore = false;
          });
        }

        if (state is WishListSaveSuccess || state is WishListRemoveSuccess) {
          _onRefresh();
        }
      },
      child: BlocBuilder<WishListBloc, WishListState>(
        builder: (context, state) {
          ///Loading
          Widget content = ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 20, top: 15),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: AppProductItem(type: ProductViewType.small),
              );
            },
            itemCount: 8,
          );

          ///Success
          if (state is WishListSuccess) {
            int count = state.wishList.length;
            if (_canLoadMore) {
              count = count + 1;
            }
            content = ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: 20,
                top: 15,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                if (index == state.wishList.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: AppProductItem(
                      type: ProductViewType.small,
                    ),
                  );
                }
                final item = state.wishList[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: AppProductItem(
                    onPressed: _onProductDetail,
                    item: item,
                    type: ProductViewType.small,
                    action: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      onSelected: (result) {
                        if (result == 'remove') {
                          AppBloc.wishListBloc.add(
                            OnRemoveWishList(
                              id: item.id,
                              index: index,
                              wishList: state.wishList,
                            ),
                          );
                        }
                        if (result == 'share' && item.link != null) {
                          Share.share(
                            'Check out my item ${item.link}',
                            subject: 'PassionUI',
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'remove',
                            child: Text(
                              Translate.of(context).translate('remove'),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'share',
                            child: Text(
                              Translate.of(context).translate('share'),
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            );

            ///Empty
            if (state.wishList.isEmpty) {
              content = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.sentiment_satisfied),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        Translate.of(context).translate('list_is_empty'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          ///Icon Remove
          Widget icon = Container();
          if (state is WishListSuccess && state.wishList.length > 0) {
            icon = IconButton(
              icon: Icon(Icons.delete),
              onPressed: _clearWishList,
            );
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(Translate.of(context).translate('wish_list')),
              actions: <Widget>[
                icon,
              ],
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: content,
              ),
            ),
          );
        },
      ),
    );
  }
}
