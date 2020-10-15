import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class Review extends StatefulWidget {
  final ProductModel product;

  Review({Key key, this.product}) : super(key: key);

  @override
  _ReviewState createState() {
    return _ReviewState();
  }
}

class _ReviewState extends State<Review> {
  @override
  void initState() {
    AppBloc.reviewBloc.add(OnLoadReview(id: widget.product.id));
    super.initState();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    AppBloc.reviewBloc.add(OnLoadReview(id: widget.product.id));
  }

  ///On navigate write review
  void _onWriteReview() async {
    if (Application.user == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.writeReview,
      );
      if (result != Routes.writeReview) {
        return;
      }
    }
    Navigator.pushNamed(
      context,
      Routes.writeReview,
      arguments: widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('review'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              Translate.of(context).translate('write'),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
            onPressed: _onWriteReview,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is ReviewSaveFail || state is ReviewSaveSuccess) {
              AppBloc.reviewBloc.add(OnLoadReview(id: widget.product.id));
            }
          },
          child: BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              RateModel rate;

              ///Loading
              Widget listComment = ListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                ),
                children: List.generate(8, (index) => index).map(
                  (item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: AppCommentItem(),
                    );
                  },
                ).toList(),
              );

              ///Success
              if (state is ReviewSuccess) {
                rate = state.rate;

                ///Empty
                if (state.review.isEmpty) {
                  listComment = Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.sentiment_satisfied),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            Translate.of(context).translate('review_not_found'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  listComment = ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    itemCount: state.review.length,
                    itemBuilder: (context, index) {
                      final item = state.review[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: AppCommentItem(item: item),
                      );
                    },
                  );
                }
              }

              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                      bottom: 15,
                    ),
                    child: rate != null
                        ? AppRating(
                            rate: rate,
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: listComment,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
