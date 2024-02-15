// To parse this JSON data, do
//
//     final ctool = ctoolFromJson(jsonString);

import 'dart:convert';

LocationModule? ctoolFromJson(String str) =>
    LocationModule.fromJson(json.decode(str));

String ctoolToJson(LocationModule? data) => json.encode(data!.toJson());

class LocationModule {
  LocationModule({
    this.callbackTime,
    this.locationTime,
    this.locationType,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.bearing,
    this.speed,
    this.country,
    this.province,
    this.city,
    this.district,
    this.street,
    this.streetNumber,
    this.cityCode,
    this.adCode,
    this.address,
    this.description,
  });

  final String? callbackTime;
  final String? locationTime;
  final int? locationType;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final double? altitude;
  final double? bearing;
  final double? speed;
  final String? country;
  final String? province;
  final String? city;
  final String? district;
  final String? street;
  final String? streetNumber;
  final String? cityCode;
  final String? adCode;
  final String? address;
  final String? description;

  factory LocationModule.fromJson(Map json) => LocationModule(
        callbackTime: json["callbackTime"],
        locationTime: json["locationTime"],
        locationType: json["locationType"],
        latitude: json["latitude"] is double
            ? json["latitude"]
            : json["latitude"].toDouble(),
        longitude: json["longitude"] is double
            ? json["longitude"]
            : json["longitude"].toDouble(),
        accuracy: json["accuracy"],
        altitude: json["altitude"],
        bearing: json["bearing"],
        speed: json["speed"],
        country: json["country"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        street: json["street"],
        streetNumber: json["streetNumber"],
        cityCode: json["cityCode"],
        adCode: json["adCode"],
        address: json["address"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "callbackTime": callbackTime,
        "locationTime": locationTime,
        "locationType": locationType,
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
        "altitude": altitude,
        "bearing": bearing,
        "speed": speed,
        "country": country,
        "province": province,
        "city": city,
        "district": district,
        "street": street,
        "streetNumber": streetNumber,
        "cityCode": cityCode,
        "adCode": adCode,
        "address": address,
        "description": description,
      };
}
