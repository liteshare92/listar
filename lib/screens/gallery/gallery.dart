import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:shimmer/shimmer.dart';

class Gallery extends StatefulWidget {
  final ProductModel product;

  Gallery({this.product}) : super();

  @override
  _GalleryState createState() {
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery> {
  final _controller = SwiperController();
  final _listController = ScrollController();

  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  ///On preview photo
  void _onPreviewPhoto(int index) {
    Navigator.pushNamed(
      context,
      Routes.photoPreview,
      arguments: {"galleries": widget.product.galleries, "index": index},
    );
  }

  ///On select image
  void _onSelectImage(int index) {
    _controller.move(index);
  }

  ///On Process index change
  void _onChange(int index) {
    setState(() {
      _index = index;
    });
    final currentOffset = (index + 1) * 94.0;
    final widthDevice = MediaQuery.of(context).size.width;

    ///Animate scroll to Overflow offset
    if (currentOffset > widthDevice) {
      _listController.animateTo(
        currentOffset - widthDevice,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      ///Move to Start offset when index not overflow
      _listController.animateTo(
        0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Swiper(
                controller: _controller,
                onIndexChanged: _onChange,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _onPreviewPhoto(index);
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.product.galleries[index].full,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(),
                        );
                      },
                    ),
                  );
                },
                itemCount: widget.product.galleries.length,
                pagination: SwiperPagination(
                  alignment: Alignment(0.0, 0.9),
                  builder: SwiperPagination.dots,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.product.title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    "${_index + 1}/${widget.product.galleries.length}",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              margin: EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                controller: _listController,
                padding: EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.galleries.length,
                itemBuilder: (context, index) {
                  final item = widget.product.galleries[index];
                  return GestureDetector(
                    onTap: () {
                      _onSelectImage(index);
                    },
                    child: CachedNetworkImage(
                      imageUrl: item.full,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 70,
                          margin: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: index == _index
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
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
                            width: 70,
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: index == _index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).dividerColor),
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
                            width: 70,
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: index == _index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
