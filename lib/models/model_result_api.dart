class ResultApiModel {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic pagination;
  final dynamic attr;
  final String code;

  ResultApiModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
    this.attr,
    this.code,
  });

  factory ResultApiModel.fromJson(Map<String, dynamic> json) {
    try {
      return ResultApiModel(
        success: json['success'] as bool ?? false,
        message: json['message'] as String ?? 'Unknown',
        data: json['data'],
        pagination: json['pagination'],
        attr: json['attr'],
        code: json['code'].toString() ?? 'Unknown',
      );
    } catch (error) {
      return ResultApiModel(
        success: false,
        data: null,
        message: "cannot init result api",
      );
    }
  }
}
