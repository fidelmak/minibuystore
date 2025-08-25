// create_product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProductModel {
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  CreateProductModel({
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required List<String> additionalImages,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {'rate': rating.rate, 'count': rating.count},
      'createdAt': FieldValue.serverTimestamp(), // Add timestamp
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // For updating existing products (preserves timestamp)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {'rate': rating.rate, 'count': rating.count},
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}
