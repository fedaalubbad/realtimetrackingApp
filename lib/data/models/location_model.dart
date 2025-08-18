class LocationModel {
  final String userId;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromMap(String userId, Map<dynamic, dynamic> map) {
    return LocationModel(
      userId: userId,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}
