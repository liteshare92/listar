class CommentModel {
  final int id;
  final String userImage;
  final String userName;
  final String comment;
  final DateTime createDate;
  final num rate;

  CommentModel({
    this.id,
    this.userImage,
    this.userName,
    this.comment,
    this.createDate,
    this.rate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    try {
      return CommentModel(
        id: int.tryParse(json['comment_ID'].toString()) ?? 0,
        userImage: json['comment_author_image'] as String ?? 'Unknown',
        userName: json['comment_author'] as String ?? 'Unknown',
        comment: json['comment_content'] as String ?? 'Unknown',
        createDate: DateTime.tryParse(json['comment_date']) ?? DateTime.now(),
        rate: double.tryParse(json['rate'].toString()) ?? 0.0,
      );
    } catch (error) {
      return null;
    }
  }
}
