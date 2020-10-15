import 'package:listar/models/model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ReviewState {}

class InitialReviewState extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final RateModel rate;
  final List<CommentModel> review;
  ReviewSuccess({this.review, this.rate});
}

class ReviewFail extends ReviewState {
  final String code;
  ReviewFail({this.code});
}

class ReviewSaving extends ReviewState {}

class ReviewSaveSuccess extends ReviewState {}

class ReviewSaveFail extends ReviewState {
  final String code;
  ReviewSaveFail({this.code});
}
