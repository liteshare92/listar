class TimeModel {
  final String key;
  final List schedule;

  TimeModel({
    this.key,
    this.schedule,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    try {
      return TimeModel(
        key: json['key'],
        schedule: json['schedule'],
      );
    } catch (error) {
      return null;
    }
  }
}
