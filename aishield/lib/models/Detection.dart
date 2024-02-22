import 'package:flutter/material.dart';

class Detection {
  final String? address;
  final String? id;
  final String selection;
  final String timestamp;
  final String? categories;
  final String? detectionImageUrl;
  final String imageUrl;
  final String latitude;
  final String longitude;

  Detection({
    this.address,
    this.id,
    required this.selection,
    required this.timestamp,
    this.categories,
    this.detectionImageUrl,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  Detection.fromMap(Map<String, dynamic> map)
      : address = map['address'] ?? "",
        id = map['id'] ?? "",
        selection = map['selection'] ?? "",
        timestamp = map['timestamp'] ?? "",
        categories = map['categories'] ?? "",
        detectionImageUrl = map['detectionImageUrl'] ?? "",
        imageUrl = map['imageUrl'] ?? "",
        latitude = map['latitude'] ?? "",
        longitude = map['longitude'] ?? "";

  Map<String, dynamic> toMap(String id) {
    return {
      'address': address,
      'id': id,
      'selection': selection,
      'timestamp': timestamp,
      'categories': categories,
      'detectionImageUrl': detectionImageUrl,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
