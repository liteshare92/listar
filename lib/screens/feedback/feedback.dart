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

class WriteReview extends StatefulWidget {
  final ProductModel product;

  WriteReview({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  _WriteReviewState createState() {
    return _WriteReviewState();
  }
}

class _WriteReviewState extends State<WriteReview> {
  final _textReview = TextEditingController();
  final _focusReview = FocusNode();

  String _validReview;
  double _rate = 0;

  @override
  void initState() {
    _rate = widget.product.rate;
    super.initState();
  }

  ///On send
  Future<void> _send() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validReview = UtilValidator.validate(
        data: _textReview.text,
      );
    });
    if (_validReview == null && _rate != 0) {
      final Map<String, dynamic> params = {
        "post": widget.product.id,
        "content": _textReview.text,
        "rating": _rate,
      };
      AppBloc.reviewBloc.add(OnReviewSave(params: params));
    } else {
      _showMessage(Translate.of(context).translate('please_input_data'));
    }
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('feedback'),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSaveSuccess) {
          Navigator.pop(context);
        }
        if (state is ReviewSaveFail) {
          _showMessage(Translate.of(context).translate(state.code));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Translate.of(context).translate('feedback'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                Translate.of(context).translate('send'),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
              onPressed: _send,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
              top: 15,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: Application.user?.image,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
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
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
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
                            child: Icon(Icons.error),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: StarRating(
                    rating: _rate,
                    size: 24,
                    color: AppTheme.yellowColor,
                    borderColor: AppTheme.yellowColor,
                    allowHalfRating: false,
                    onRatingChanged: (value) {
                      setState(() {
                        _rate = value;
                      });
                    },
                  ),
                ),
                Text(
                  Translate.of(context).translate('tap_rate'),
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          Translate.of(context).translate('description'),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AppTextInput(
                        hintText: Translate.of(context).translate(
                          'input_feedback',
                        ),
                        errorText:
                            Translate.of(context).translate(_validReview),
                        focusNode: _focusReview,
                        maxLines: 5,
                        onTapIcon: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          _textReview.clear();
                        },
                        onSubmitted: (text) {
                          _send();
                        },
                        onChanged: (text) {
                          setState(() {
                            _validReview = UtilValidator.validate(
                              data: _textReview.text,
                            );
                          });
                        },
                        icon: Icon(Icons.clear),
                        controller: _textReview,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
