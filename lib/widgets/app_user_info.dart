import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listar/models/model.dart';
import 'package:shimmer/shimmer.dart';

enum AppUserType { basic, information }

class AppUserInfo extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPressed;
  final AppUserType type;

  AppUserInfo({
    Key key,
    this.user,
    this.onPressed,
    this.type = AppUserType.basic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      switch (type) {
        case AppUserType.information:
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
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
                          padding: EdgeInsets.only(top: 3, bottom: 3),
                          child: Container(
                            height: 10,
                            width: 100,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 10,
                          width: 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        default:
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
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
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
      }
    }

    switch (type) {
      case AppUserType.information:
        return InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: user.image,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Theme.of(context).hoverColor,
                        highlightColor: Theme.of(context).highlightColor,
                        enabled: true,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
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
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "${user.rate}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.name,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle2),
                      Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 3),
                        child: Text(
                          user.description,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Text(
                        user.nickname,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Container(
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: user.image,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.error),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              )
            ],
          ),
        );
    }
  }
}
