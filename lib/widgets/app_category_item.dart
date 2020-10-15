import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listar/models/model.dart';
import 'package:shimmer/shimmer.dart';

enum CategoryView { full, icon, cardLarge }

class AppCategory extends StatelessWidget {
  AppCategory({
    Key key,
    this.type = CategoryView.full,
    this.item,
    this.onPressed,
    this.bottomLine = true,
  }) : super(key: key);

  final CategoryView type;
  final CategoryModel item;
  final ValueChanged<CategoryModel> onPressed;
  final bool bottomLine;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CategoryView.full:
        if (item == null) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: Container(
              height: 120,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => onPressed(item),
          child: Container(
            height: 120,
            child: CachedNetworkImage(
              imageUrl: item.image.full,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.color,
                              ),
                              child: Icon(
                                item.icon,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${item.count} location',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
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
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
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
          ),
        );

      case CategoryView.icon:
        if (item == null) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 8,
                          width: 100,
                          color: Colors.white,
                        ),
                        Container(
                          height: 8,
                          width: 100,
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 4),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return InkWell(
          onTap: () => onPressed(item),
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              border: bottomLine
                  ? Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    )
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: item.color,
                  ),
                  child: Icon(
                    item.icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${item.count} location',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );

      ///Case View Card large
      case CategoryView.cardLarge:
        if (item == null) {
          return SizedBox(
            width: 135,
            height: 160,
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
          width: 135,
          height: 160,
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
              child: CachedNetworkImage(
                imageUrl: item.image.full,
                imageBuilder: (context, imageProvider) {
                  return Container(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            item.title,
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
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
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
