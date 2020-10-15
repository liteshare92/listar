import 'package:listar/models/model.dart';

class ProductModel {
  final int id;
  final String title;
  final ImageModel image;
  final CategoryModel category;
  final String createDate;
  final String dateEstablish;
  final double rate;
  final num numRate;
  final String rateText;
  final String status;
  bool favorite;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String description;
  final num priceMin;
  final num priceMax;
  final List<ImageModel> galleries;
  final List<CategoryModel> features;
  final List<ProductModel> related;
  final List<ProductModel> lastest;
  final List<TimeModel> openHours;
  final LocationModel location;
  final String link;

  ProductModel({
    this.id,
    this.title,
    this.image,
    this.category,
    this.createDate,
    this.dateEstablish,
    this.rate,
    this.numRate,
    this.rateText,
    this.status,
    this.favorite,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.description,
    this.priceMin,
    this.priceMax,
    this.galleries,
    this.features,
    this.related,
    this.lastest,
    this.openHours,
    this.location,
    this.link,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      final category = CategoryModel.fromJson(json['category']);
      final location = LocationModel.fromJson({
        "name": json['post_title'],
        "latitude": json['latitude'],
        "longitude": json['longitude']
      });
      final Iterable refactorCategory = json['features'] ?? [];
      final Iterable refactorRelated = json['related'] ?? [];
      final Iterable refactorLastest = json['lastest'] ?? [];
      final Iterable refactorGalleries = json['galleries'] ?? [];
      final Iterable refactorOpenHour = json['opening_hour'] ?? [];

      final galleries = refactorGalleries.map((item) {
        return ImageModel.fromJson(item);
      }).toList();

      final listCategory = refactorCategory.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      final listRelated = refactorRelated.map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      final listLastest = refactorLastest.map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      final listOpenHour = refactorOpenHour.map((item) {
        return TimeModel.fromJson(item);
      }).toList();

      return ProductModel(
        id: int.tryParse(json['ID'].toString()) ?? 0,
        title: json['post_title'] as String ?? 'Unknown',
        image: ImageModel.fromJson(json['image']),
        category: category,
        createDate: json['post_date'] as String ?? 'Unknown',
        dateEstablish: json['date_establish'] as String ?? 'Unknown',
        rate: double.tryParse(json['rating_avg'].toString()) ?? 0.0,
        numRate: json['rating_count'] as int ?? 0,
        rateText: json['post_status'] as String ?? 'Unknown',
        status: json['status'] as String ?? 'Unknown',
        favorite: json['wishlist'] as bool ?? false,
        address: json['address'] as String ?? 'Unknown',
        phone: json['phone'] as String ?? 'Unknown',
        email: json['email'] as String ?? 'Unknown',
        website: json['website'] as String ?? 'Unknown',
        description: json['post_excerpt'] as String ?? 'Unknown',
        priceMin: json['price_min'] as num ?? 0,
        priceMax: json['price_max'] as num ?? 0,
        features: listCategory,
        galleries: galleries,
        related: listRelated,
        lastest: listLastest,
        openHours: listOpenHour,
        location: location,
        link: json['guid'] as String ?? 'Unknown',
      );
    } catch (error) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {"ID": id, "post_title": title};
  }
}
