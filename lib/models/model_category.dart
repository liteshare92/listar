import 'package:flutter/cupertino.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';

enum CategoryType { category, location, feature }

class CategoryModel {
  final int id;
  final String title;
  final int count;
  final ImageModel image;
  final IconData icon;
  final Color color;
  final CategoryType type;

  CategoryModel({
    this.id,
    this.title,
    this.count,
    this.image,
    this.icon,
    this.color,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      CategoryType categoryType = CategoryType.category;
      if (json['taxonomy'] == 'listar_feature') {
        categoryType = CategoryType.feature;
      }
      if (json['taxonomy'] == 'listar_location') {
        categoryType = CategoryType.location;
      }
      final icon = UtilIcon.getIconData(json['icon']);
      final color = UtilColor.getColorFromHex(json['color']);
      return CategoryModel(
        id: json['term_id'] as int ?? 0,
        title: json['name'] as String ?? 'Unknown',
        count: json['count'] as int ?? 0,
        image: ImageModel.fromJson(json['image']),
        icon: icon,
        color: color,
        type: categoryType,
      );
    } catch (error) {
      return null;
    }
  }
}
