import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/product_repository.dart';

import 'bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(InitialReviewState());
  final ProductRepository productRepository = ProductRepository();

  @override
  Stream<ReviewState> mapEventToState(ReviewEvent event) async* {
    if (event is OnLoadReview) {
      yield ReviewLoading();

      ///Fetch API
      final ResultApiModel result = await productRepository.getReview(
        {"post_id": event.id},
      );
      if (result.success) {
        final Iterable refactorComment = result?.data ?? [];
        final listComment = refactorComment.map((item) {
          return CommentModel.fromJson(item);
        }).toList();
        RateModel rate;
        if (result.attr['rating'] != null) {
          rate = RateModel.fromJson(result.attr['rating']);
        }

        ///Sync UI
        yield ReviewSuccess(review: listComment, rate: rate);
      } else {
        yield ReviewFail(code: result.code);
      }
    }

    if (event is OnReviewSave) {
      yield ReviewSaving();

      ///Fetch API
      final ResultApiModel result = await productRepository.saveReview(
        event.params,
      );
      if (result.success) {
        yield ReviewSaveSuccess();
      } else {
        yield ReviewSaveFail(code: result.code);
      }
    }
  }
}
