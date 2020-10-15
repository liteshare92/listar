class PaginationModel {
  final int page;
  final int perPage;
  final int maxPage;
  final int total;

  PaginationModel({this.page, this.perPage, this.maxPage, this.total});

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    try {
      return PaginationModel(
        page: json['page'] as int ?? 0,
        perPage: json['per_page'] as int ?? 0,
        maxPage: json['max_page'] as int ?? 0,
        total: json['total'] as int ?? 0,
      );
    } catch (error) {
      return null;
    }
  }
}
