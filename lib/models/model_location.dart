class LocationModel {
  final String name;
  final double longitude;
  final double latitude;

  LocationModel({
    this.name,
    this.longitude,
    this.latitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    try {
      return LocationModel(
        name: json['name'] as String ?? 'Unknown',
        longitude: double.tryParse(json['longitude']) ?? 0.0,
        latitude: double.tryParse(json['latitude']) ?? 0.0,
      );
    } catch (error) {
      return null;
    }
  }
}
