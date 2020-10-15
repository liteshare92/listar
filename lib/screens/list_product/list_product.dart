import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/blocs/list/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class ListProduct extends StatefulWidget {
  final CategoryModel category;

  ListProduct({Key key, this.category}) : super(key: key);

  @override
  _ListProductState createState() {
    return _ListProductState();
  }
}

class _ListProductState extends State<ListProduct> {
  final _swipeController = SwiperController();
  final _scrollController = ScrollController();
  final _endReachedThreshold = 500;
  List<ProductModel> _list = [];
  PaginationModel _pagination;
  int _page = 1;
  bool _loadingMore = false;
  bool _canLoadMore = true;

  GoogleMapController _mapController;
  int _indexLocation = 0;
  MapType _mapType = MapType.normal;
  PageType _pageType = PageType.list;
  ProductViewType _modeView = ListSetting.modeView;
  List<CategoryModel> _category = [];
  List<CategoryModel> _feature = [];
  CategoryModel _location;
  SortModel _currentSort;
  double _minPrice;
  double _maxPrice;
  String _color;
  TimeOfDay _startHour = ListSetting.startHour;
  TimeOfDay _endHour = ListSetting.endHour;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    if (ListSetting.sort.isNotEmpty) {
      _currentSort = ListSetting.sort[0];
    }
    if (widget.category.type == CategoryType.category) {
      _category.add(widget.category);
    }
    if (widget.category.type == CategoryType.feature) {
      _feature.add(widget.category);
    }
    if (widget.category.type == CategoryType.location) {
      _location = widget.category;
    }
    setState(() {
      _currentSort = _currentSort;
      _category = _category;
      _feature = _feature;
      _location = _location;
    });
    _onRefresh();
    super.initState();
  }

  ///On load more
  Future<void> _onLoadMore(List<ProductModel> list) async {
    setState(() {
      _loadingMore = true;
    });
    AppBloc.listBloc.add(
      OnLoadMoreList(
        category: _category,
        feature: _feature,
        location: _location,
        priceMin: _minPrice,
        priceMax: _maxPrice,
        color: _color,
        sort: _currentSort,
        page: _page + 1,
        list: list,
      ),
    );
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    if (!_loadingMore &&
        _canLoadMore &&
        AppBloc.listBloc.state is ListLoadSuccess) {
      _onLoadMore(_list);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    AppBloc.listBloc.add(
      OnLoadList(
        category: _category,
        feature: _feature,
        location: _location,
        priceMin: _minPrice,
        priceMax: _maxPrice,
        color: _color,
        sort: _currentSort,
      ),
    );
  }

  ///On Change Sort
  void _onChangeSort() {
    if (ListSetting.sort.isNotEmpty) {
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return AppModelBottomSheet(
            selected: _currentSort,
            option: ListSetting.sort,
            onChange: (item) {
              setState(() {
                _currentSort = item;
              });
              _onRefresh();
            },
          );
        },
      );
    }
  }

  ///On Change View
  void _onChangeView() {
    ///Icon for MapType
    if (_pageType == PageType.map) {
      switch (_mapType) {
        case MapType.normal:
          _mapType = MapType.hybrid;
          break;
        case MapType.hybrid:
          _mapType = MapType.normal;
          break;
        default:
          _mapType = MapType.normal;
          break;
      }
    }

    switch (_modeView) {
      case ProductViewType.gird:
        _modeView = ProductViewType.list;
        break;
      case ProductViewType.list:
        _modeView = ProductViewType.block;
        break;
      case ProductViewType.block:
        _modeView = ProductViewType.gird;
        break;
      default:
        return;
    }
    setState(() {
      _modeView = _modeView;
      _mapType = _mapType;
    });
  }

  ///On change filter
  void _onChangeFilter() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.filter,
      arguments: new ListFilter(
        category: _category,
        feature: _feature,
        location: _location,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        color: _color,
        startHour: _startHour,
        endHour: _endHour,
      ),
    );
    if (result != null && result is ListFilter) {
      setState(() {
        _category = result.category;
        _feature = result.feature;
        _location = result.location;
        _minPrice = result.minPrice;
        _maxPrice = result.maxPrice;
        _color = result.color;
        _startHour = result.startHour;
        _endHour = result.endHour;
      });
      _onRefresh();
    }
  }

  ///On change page
  void _onChangePageStyle() {
    switch (_pageType) {
      case PageType.list:
        setState(() {
          _pageType = PageType.map;
        });
        return;
      case PageType.map:
        setState(() {
          _pageType = PageType.list;
        });
        return;
    }
  }

  ///On tap marker map location
  void _onSelectLocation(int index) {
    _swipeController.move(index);
  }

  ///Handle Index change list map view
  void _onIndexChange(int index, ProductModel item) {
    setState(() {
      _indexLocation = index;
    });

    ///Camera animated
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: LatLng(
            item.location.latitude,
            item.location.longitude,
          ),
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///Export Icon for Mode View
  IconData _exportIconView() {
    ///Icon for MapType
    if (_pageType == PageType.map) {
      switch (_mapType) {
        case MapType.normal:
          return Icons.satellite;
        case MapType.hybrid:
          return Icons.map;
        default:
          return Icons.help;
      }
    }

    ///Icon for ListView Mode
    switch (_modeView) {
      case ProductViewType.list:
        return Icons.view_list;
      case ProductViewType.gird:
        return Icons.view_quilt;
      case ProductViewType.block:
        return Icons.view_array;
      default:
        return Icons.help;
    }
  }

  ///_build Item Loading
  Widget _buildItemLoading(ProductViewType type) {
    switch (type) {
      case ProductViewType.gird:
        return AppProductItem(
          type: _modeView,
        );

      case ProductViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppProductItem(
            type: _modeView,
          ),
        );

      default:
        return AppProductItem(
          type: _modeView,
        );
    }
  }

  ///_build Item
  Widget _buildItem(ProductModel item, ProductViewType type) {
    switch (type) {
      case ProductViewType.gird:
        return AppProductItem(
          onPressed: _onProductDetail,
          item: item,
          type: _modeView,
        );

      case ProductViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppProductItem(
            onPressed: _onProductDetail,
            item: item,
            type: _modeView,
          ),
        );

      default:
        return AppProductItem(
          onPressed: _onProductDetail,
          item: item,
          type: _modeView,
        );
    }
  }

  ///Build Content Page Style
  Widget _buildContent() {
    return BlocListener<WishListBloc, WishListState>(
      listener: (context, listen) {
        if (listen is WishListRemoveSuccess) {
          AppBloc.listBloc.add(
            OnWishListChange(
              id: listen.id,
              list: _list,
              pagination: _pagination,
            ),
          );
        }
        if (listen is WishListSaveSuccess) {
          AppBloc.listBloc.add(
            OnWishListChange(
              id: listen.id,
              list: _list,
              pagination: _pagination,
            ),
          );
        }
      },
      child: BlocListener<ListBloc, ListState>(
        listener: (context, state) {
          if (state is ListLoadSuccess) {
            setState(() {
              _list = state.list;
              _pagination = state.pagination;
              _canLoadMore = state.pagination.page < state.pagination.maxPage;
              _page = state.pagination.page;
              _loadingMore = false;
            });
          }
        },
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            /// ListStyle
            if (_pageType == PageType.list) {
              Widget contentList = ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: _buildItemLoading(_modeView),
                  );
                },
                itemCount: 8,
              );
              if (_modeView == ProductViewType.gird) {
                final size = MediaQuery.of(context).size;
                final left = MediaQuery.of(context).padding.left;
                final right = MediaQuery.of(context).padding.right;
                final itemHeight = 220;
                final itemWidth = (size.width - 48 - left - right) / 2;
                final ratio = itemWidth / itemHeight;
                contentList = GridView.count(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: ratio,
                  children: List.generate(8, (index) => index).map((item) {
                    return _buildItemLoading(_modeView);
                  }).toList(),
                );
              }

              ///Build List
              if (state is ListLoadSuccess) {
                List<ProductModel> list = state.list;
                if (_canLoadMore) {
                  list = new List.from(state.list);
                  list.add(null);
                }
                contentList = ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 8),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    if (item == null) {
                      return Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: _buildItemLoading(_modeView),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildItem(item, _modeView),
                    );
                  },
                  itemCount: list.length,
                );
                if (_modeView == ProductViewType.gird) {
                  final size = MediaQuery.of(context).size;
                  final left = MediaQuery.of(context).padding.left;
                  final right = MediaQuery.of(context).padding.right;
                  final itemHeight = 220;
                  final itemWidth = (size.width - 48 - left - right) / 2;
                  final ratio = itemWidth / itemHeight;
                  contentList = GridView.count(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    crossAxisCount: 2,
                    childAspectRatio: ratio,
                    children: list.map((item) {
                      if (item == null) {
                        return _buildItemLoading(_modeView);
                      }
                      return _buildItem(item, _modeView);
                    }).toList(),
                  );
                }

                ///Build List empty
                if (state.list.isEmpty) {
                  contentList = Center(
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

              /// List
              return SafeArea(
                child: contentList,
              );
            }

            ///Map Style
            Widget listProductMapView = Container();

            ///Build Map
            if (state is ListLoadSuccess) {
              ///Default value map
              CameraPosition initPosition = CameraPosition(
                target: LatLng(
                  40.697403,
                  -74.1201063,
                ),
                zoom: 14.4746,
              );
              Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

              ///Not build swipe and action when empty
              Widget list = Container();

              ///Build swipe if list not empty
              if (state.list.isNotEmpty) {
                initPosition = CameraPosition(
                  target: LatLng(
                    state.list[0].location?.latitude,
                    state.list[0].location?.longitude,
                  ),
                  zoom: 14.4746,
                );

                ///Setup list marker map from list
                state.list.forEach((item) {
                  final markerId = MarkerId(item.id.toString());
                  final marker = Marker(
                    markerId: markerId,
                    position: LatLng(
                      item.location.latitude,
                      item.location.longitude,
                    ),
                    infoWindow: InfoWindow(title: item.title),
                    onTap: () {
                      _onSelectLocation(state.list.indexOf(item));
                    },
                  );
                  markers[markerId] = marker;
                });

                ///build list map
                list = SafeArea(
                  bottom: false,
                  top: false,
                  child: Container(
                    height: 210,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: 36,
                                height: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).dividerColor,
                                      blurRadius: 5,
                                      spreadRadius: 1.0,
                                      offset: Offset(1.5, 1.5),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  Icons.directions,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).dividerColor,
                                        blurRadius: 5,
                                        spreadRadius: 1.0,
                                        offset: Offset(1.5, 1.5),
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Swiper(
                            itemBuilder: (context, index) {
                              final ProductModel item = state.list[index];
                              return Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _indexLocation == index
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).dividerColor,
                                        blurRadius: 5,
                                        spreadRadius: 1.0,
                                        offset: Offset(1.5, 1.5),
                                      )
                                    ],
                                  ),
                                  child: AppProductItem(
                                    onPressed: _onProductDetail,
                                    item: item,
                                    type: ProductViewType.list,
                                  ),
                                ),
                              );
                            },
                            controller: _swipeController,
                            onIndexChanged: (index) {
                              final ProductModel item = state.list[index];
                              _onIndexChange(index, item);
                            },
                            itemCount: state.list.length,
                            viewportFraction: 0.8,
                            scale: 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              ///build Map
              listProductMapView = Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      mapType: _mapType,
                      initialCameraPosition: initPosition,
                      markers: Set<Marker>.of(markers.values),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                    list
                  ],
                ),
              );
            }

            return listProductMapView;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('listing')),
        actions: <Widget>[
          BlocBuilder<ListBloc, ListState>(
            builder: (context, state) {
              return Visibility(
                visible: state is ListLoadSuccess,
                child: IconButton(
                  icon: Icon(
                    _pageType == PageType.map ? Icons.view_compact : Icons.map,
                  ),
                  onPressed: _onChangePageStyle,
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              return AppNavBar(
                currentSort: _currentSort,
                onChangeSort: _onChangeSort,
                iconModeView: _exportIconView(),
                onChangeView: _onChangeView,
                onFilter: () {
                  if (state is FilterSuccess) {
                    _onChangeFilter();
                  }
                },
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildContent(),
            ),
          )
        ],
      ),
    );
  }
}

class ListFilter {
  List<CategoryModel> category;
  List<CategoryModel> feature;
  CategoryModel location;
  num minPrice;
  num maxPrice;
  String color;
  TimeOfDay startHour;
  TimeOfDay endHour;

  ListFilter({
    this.category,
    this.feature,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.color,
    this.startHour,
    this.endHour,
  });
}
