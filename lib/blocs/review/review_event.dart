import 'package:meta/meta.dart';

@immutable
abstract class ReviewEvent {}

class OnLoadReview extends ReviewEvent {
  final int id;
  OnLoadReview({this.id});
}

class OnReviewSave extends ReviewEvent {
  final Map<String, dynamic> params;
  OnReviewSave({this.params});
}
