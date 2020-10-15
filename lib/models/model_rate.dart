import 'package:listar/utils/logger.dart';

class RateModel {
  final double one;
  final double two;
  final double three;
  final double four;
  final double five;
  final double avg;
  final int total;

  RateModel({
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.avg,
    this.total,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    try {
      return RateModel(
        one: json['rating_meta']['1'] / json['rating_count'] as double ?? 0.0,
        two: json['rating_meta']['2'] / json['rating_count'] as double ?? 0.0,
        three: json['rating_meta']['3'] / json['rating_count'] as double ?? 0.0,
        four: json['rating_meta']['4'] / json['rating_count'] as double ?? 0.0,
        five: json['rating_meta']['5'] / json['rating_count'] as double ?? 0.0,
        avg: double.tryParse(json['rating_avg'].toString()) ?? 0.0,
        total: json['rating_count'] as int ?? 0,
      );
    } catch (error) {
      UtilLogger.log("ERROR", error);
      return null;
    }
  }
}
