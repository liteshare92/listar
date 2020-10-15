import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shimmer/shimmer.dart';

class HomeSwipe extends StatelessWidget {
  final double height;
  final List<String> images;

  HomeSwipe({
    Key key,
    this.images,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images != null) {
      return Swiper(
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: images[index],
            placeholder: (context, url) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Container(
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
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Container(
                    color: Colors.white,
                    child: Icon(Icons.error),
                  ),
                ),
              );
            },
          );
        },
        autoplayDelay: 3000,
        autoplayDisableOnInteraction: false,
        autoplay: true,
        itemCount: images.length,
        pagination: SwiperPagination(
          alignment: Alignment(0.0, 0.4),
          builder: SwiperPagination.dots,
        ),
      );
    }
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
