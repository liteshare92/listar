import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.id}) : super(key: key);

  final int id;

  @override
  _ProductDetailState createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetail> {
  bool _favorite = false;
  bool _showHour = true;

  @override
  void initState() {
    AppBloc.productDetailBloc.add(OnLoadProduct(id: widget.id));
    super.initState();
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item.id);
  }

  ///On navigate map
  void _onLocation(ProductModel item) {
    Navigator.pushNamed(
      context,
      Routes.location,
      arguments: item.location,
    );
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('product'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                Translate.of(context).translate('close'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///On navigate gallery
  void _onPhotoPreview(ProductModel item) {
    if (item.galleries.length == 0) {
      _showMessage(Translate.of(context).translate("galleries_empty"));
    } else {
      Navigator.pushNamed(
        context,
        Routes.gallery,
        arguments: item,
      );
    }
  }

  ///On navigate review
  void _onReview(ProductModel product) {
    Navigator.pushNamed(
      context,
      Routes.review,
      arguments: product,
    );
  }

  ///On like product
  void _onLike(ProductModel item) async {
    if (Application.user == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.productDetail,
      );
      if (result != Routes.productDetail) {
        return;
      }
      await Future.delayed(Duration(seconds: 1));
    }
    if (_favorite) {
      AppBloc.wishListBloc.add(OnRemoveWishList(id: item.id));
    } else {
      AppBloc.wishListBloc.add(OnAddWishList(id: item.id));
    }
    setState(() {
      _favorite = !_favorite;
    });
  }

  Future<void> _makeAction(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showMessage(Translate.of(context).translate('cannot_make_action'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSaveSuccess) {
            AppBloc.productDetailBloc.add(OnLoadProduct(id: widget.id));
          }
        },
        child: BlocListener<WishListBloc, WishListState>(
          listener: (context, state) {
            if (state is WishListSaveFail || state is WishListRemoveFail) {
              setState(() {
                _favorite = !_favorite;
              });
              _showMessage(
                Translate.of(context).translate("error_update_wishlist"),
              );
            }
          },
          child: BlocListener<ProductDetailBloc, ProductDetailState>(
            listener: (context, state) {
              if (state is ProductDetailSuccess) {
                setState(() {
                  _favorite = state.product.favorite;
                });
              }
            },
            child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                ///Build UI loading
                List<Widget> action = [];
                Widget background = Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Container(
                    color: Colors.white,
                  ),
                );
                UserModel author;
                Widget description = Container();
                Widget facilities = Container();
                Widget info = Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 20,
                            top: 20,
                          ),
                          height: 10,
                          width: 150,
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Container(
                                  height: 20,
                                  width: 150,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                              width: 100,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 200,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 200,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 200,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 200,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 200,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Container(height: 10, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(height: 10, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(height: 10, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(height: 10, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(height: 10, color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(height: 10, color: Colors.white),
                        ),
                        description,
                        facilities
                      ],
                    ),
                  ),
                );
                Widget status = Container();
                Widget feature = Container();
                Widget related = Container();

                ///Build UI success
                if (state is ProductDetailSuccess) {
                  String currency = ListSetting.unit;
                  action = [
                    IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {
                        _onLocation(state.product);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () {
                        _onPhotoPreview(state.product);
                      },
                    )
                  ];
                  background = CachedNetworkImage(
                    imageUrl: state.product.image.full,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Theme.of(context).hoverColor,
                        highlightColor: Theme.of(context).highlightColor,
                        enabled: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Shimmer.fromColors(
                        baseColor: Theme.of(context).hoverColor,
                        highlightColor: Theme.of(context).highlightColor,
                        enabled: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  );
                  author = state.author;
                  if (state.product.status.isNotEmpty) {
                    status = AppTag(
                      state.product.status,
                      type: TagType.status,
                    );
                  }
                  if (state.product.description.isNotEmpty) {
                    description = Text(
                      state.product.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(height: 1.3),
                    );
                  }
                  if (state.product.features.isNotEmpty) {
                    facilities = Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                Translate.of(context).translate('facilities'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: state.product.features.map((item) {
                                return IntrinsicWidth(
                                  child: AppTag(
                                    item.title,
                                    type: TagType.chip,
                                    icon: Icon(
                                      item.icon,
                                      size: 12,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  info = Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                state.product.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              onPressed: () {
                                _onLike(state.product);
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _onReview(state.product);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    state.product.category.title,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      AppTag(
                                        "${state.product.rate}",
                                        type: TagType.rateSmall,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      StarRating(
                                        rating: state.product.rate,
                                        size: 14,
                                        color: AppTheme.yellowColor,
                                        borderColor: AppTheme.yellowColor,
                                        onRatingChanged: (v) {
                                          _onReview(state.product);
                                        },
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 5)),
                                      Text(
                                        "(${state.product.numRate})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            status,
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        InkWell(
                          onTap: () {
                            _makeAction(
                              'https://www.google.com/maps/search/?api=1&query=${state.product.location.latitude},${state.product.location.longitude}',
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).dividerColor,
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Translate.of(context)
                                            .translate('address'),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        state.product.address,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        InkWell(
                          onTap: () {
                            _makeAction('tel:${state.product.phone}');
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).dividerColor,
                                ),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Translate.of(context)
                                            .translate('phone'),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        state.product.phone,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        InkWell(
                          onTap: () {
                            _makeAction('mailto:${state.product.email}');
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).dividerColor),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Translate.of(context)
                                            .translate('email'),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        state.product.email,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        InkWell(
                          onTap: () {
                            _makeAction(state.product.website);
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).dividerColor,
                                ),
                                child: Icon(
                                  Icons.language,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Translate.of(context)
                                            .translate('website'),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(
                                        state.product.website,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showHour = !_showHour;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      child: Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            Translate.of(context)
                                                .translate('open_time'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                _showHour
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _showHour,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.product.openHours.map((item) {
                              final hour = item.schedule
                                  .map((e) {
                                    return '${e['start']}-${e['end']}';
                                  })
                                  .toList()
                                  .join(",");
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 42,
                                ),
                                padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      Translate.of(context).translate(item.key),
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                    ),
                                    Expanded(
                                      child: Text(
                                        hour,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        description,
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    Translate.of(context).translate(
                                      'date_established',
                                    ),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                    child: Text(
                                      state.product.dateEstablish,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    Translate.of(context)
                                        .translate('price_range'),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                    child: Text(
                                      "$currency ${state.product.priceMin} - ${state.product.priceMax} $currency",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        facilities
                      ],
                    ),
                  );
                  if (state.product.lastest.isNotEmpty) {
                    feature = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 15,
                          ),
                          child: Text(
                            Translate.of(context).translate('featured'),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20),
                            itemBuilder: (context, index) {
                              final ProductModel item =
                                  state.product.lastest[index];
                              return Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.only(right: 15),
                                child: AppProductItem(
                                  onPressed: _onProductDetail,
                                  item: item,
                                  type: ProductViewType.gird,
                                ),
                              );
                            },
                            itemCount: state.product.lastest.length,
                          ),
                        )
                      ],
                    );
                  }
                  if (state.product.related.isNotEmpty) {
                    related = Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              Translate.of(context).translate('related'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Column(
                            children: state.product.related.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: AppProductItem(
                                  onPressed: _onProductDetail,
                                  item: item,
                                  type: ProductViewType.small,
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    );
                  }
                }

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 200.0,
                      pinned: true,
                      actions: action,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: background,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: AppUserInfo(
                                  user: author,
                                  onPressed: () {},
                                  type: AppUserType.basic,
                                ),
                              ),
                              info,
                              feature,
                              related,
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
