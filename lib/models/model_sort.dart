class SortModel {
  final String name;
  final String value;
  final String field;

  SortModel(
    this.name,
    this.value,
    this.field,
  );

  factory SortModel.fromJson(Map<String, dynamic> json) {
    return SortModel(
      json['lang_key'] as String ?? "Unknown",
      json['field'] as String ?? "Unknown",
      json['value'] as String ?? "Unknown",
    );
  }
}
