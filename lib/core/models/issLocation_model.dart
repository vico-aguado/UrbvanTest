import 'dart:convert';

class ISSLocationModel {
  int timestamp;
  String message;
  double latitude;
  double longitude;
  ISSLocationModel({
    this.timestamp,
    this.message,
    this.latitude,
    this.longitude,
  });

  ISSLocationModel copyWith({
    int timestamp,
    String message,
    double latitude,
    double longitude,
  }) {
    return ISSLocationModel(
      timestamp: timestamp ?? this.timestamp,
      message: message ?? this.message,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ISSLocationModel.fromMap(Map<String, dynamic> map) {
    double _latitude = 0;
    double _longitude = 0;

    if (map['iss_position'] != null) {
      Map<String, dynamic> position = map['iss_position'];
      _latitude = double.tryParse(position['latitude']) ?? 0;
      _longitude = double.tryParse(position['longitude']) ?? 0;
    }

    return ISSLocationModel(
      timestamp: map['timestamp'],
      message: map['message'],
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  String toJson() => json.encode(toMap());

  factory ISSLocationModel.fromJson(String source) => ISSLocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ISSLocationModel(timestamp: $timestamp, message: $message, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ISSLocationModel && other.timestamp == timestamp && other.message == message && other.latitude == latitude && other.longitude == longitude;
  }

  @override
  int get hashCode {
    return timestamp.hashCode ^ message.hashCode ^ latitude.hashCode ^ longitude.hashCode;
  }
}
