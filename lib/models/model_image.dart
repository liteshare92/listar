class ImageModel {
  final String full;
  final String thumb;

  ImageModel({
    this.full,
    this.thumb,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    try {
      return ImageModel(
        full: json['full']['url'],
        thumb: json['thumb']['url'],
      );
    } catch (error) {
      return ImageModel(
        full: '',
        thumb: '',
      );
    }
  }
}
