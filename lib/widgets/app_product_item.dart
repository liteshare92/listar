import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

enum ProductViewType { small, gird, list, block, cardLarge, cardSmall }
enum ProductAction { removeWishList }

class AppProductItem extends StatelessWidget {
  AppProductItem({
    Key key,
    this.item,
    this.onPressed,
    this.type,
    this.action,
  }) : super(key: key);

  final ProductModel item;
  final ProductViewType type;
  final Function(ProductModel) onPressed;
  final PopupMenuButton action;

  @override
  Widget build(BuildContext context) {
    switch (type) {

      ///Mode View Small
      case ProductViewType.small:
        if (item == null) {
          return Shimmer.fromColors(
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 180,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
          );
        }

        return FlatButton(
          onPressed: () {
            onPressed(item);
          },
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item.image.full,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      width: 80,
                      height: 80,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        item.category?.title ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AppTag(
                            "${item.rate}",
                            type: TagType.rateSmall,
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          StarRating(
                            rating: item.rate.toDouble(),
                            size: 14,
                            color: AppTheme.yellowColor,
                            borderColor: AppTheme.yellowColor,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              action ?? Container()
            ],
          ),
        );

      ///Mode View Gird
      case ProductViewType.gird:
        if (item == null) {
          return Shimmer.fromColors(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  height: 20,
                  width: 100,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
          );
        }
        return FlatButton(
          onPressed: () {
            onPressed(item);
          },
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: item.image.full,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              item.status.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.all(5),
                                      child: AppTag(
                                        item.status,
                                        type: TagType.status,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  item.favorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).hoverColor,
                      highlightColor: Theme.of(context).highlightColor,
                      enabled: true,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.white,
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
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Icon(Icons.error),
                      ),
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 3)),
                Text(
                  item.category.title,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  item.title,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AppTag(
                      "${item.rate}",
                      type: TagType.rateSmall,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    StarRating(
                      rating: item.rate.toDouble(),
                      size: 14,
                      color: AppTheme.yellowColor,
                      borderColor: AppTheme.yellowColor,
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  item.address,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        );

      ///Mode View List
      case ProductViewType.list:
        if (item == null) {
          return Shimmer.fromColors(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 80,
                          color: Colors.white,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 20,
                          width: 80,
                          color: Colors.white,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                          height: 10,
                          width: 80,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: 18,
                                height: 18,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
          );
        }

        return FlatButton(
          onPressed: () {
            onPressed(item);
          },
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item.image.full,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        item.status.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.all(5),
                                child: AppTag(
                                  item.status,
                                  type: TagType.status,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 120,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
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
                      width: 120,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.category.title,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        item.title,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AppTag(
                            "${item.rate}",
                            type: TagType.rateSmall,
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          StarRating(
                            rating: item.rate.toDouble(),
                            size: 12,
                            color: AppTheme.yellowColor,
                            borderColor: AppTheme.yellowColor,
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child: Text(item.address,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.caption),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child: Text(item.phone,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.caption),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            item.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );

      ///Mode View Block
      case ProductViewType.block:
        if (item == null) {
          return Shimmer.fromColors(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
          );
        }

        return FlatButton(
          onPressed: () {
            onPressed(item);
          },
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item.image.full,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              item.status.isNotEmpty
                                  ? AppTag(
                                      item.status,
                                      type: TagType.status,
                                    )
                                  : Container(),
                              Icon(
                                item.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      AppTag(
                                        "${item.rate}",
                                        type: TagType.rateSmall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 3),
                                              child: Text(
                                                Translate.of(context)
                                                    .translate('rate'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                            StarRating(
                                              rating: item.rate.toDouble(),
                                              size: 14,
                                              color: AppTheme.yellowColor,
                                              borderColor: AppTheme.yellowColor,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                    child: Text(
                                      "${item.numRate} ${Translate.of(context).translate('feedback')}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      height: 200,
                      color: Colors.white,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      height: 200,
                      color: Colors.white,
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.category.title,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                      item.title,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            child: Text(
                              item.address,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 3, right: 3),
                            child: Text(
                              item.phone,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      ///Case View Card small
      case ProductViewType.cardSmall:
        if (item == null) {
          return SizedBox(
            width: 100,
            height: 100,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        }

        return SizedBox(
          width: 100,
          height: 100,
          child: GestureDetector(
            onTap: () {
              onPressed(item);
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(item.image.full),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );

      default:
        return Container(width: 160.0);
    }
  }
}
