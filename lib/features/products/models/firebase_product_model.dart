import 'package:cloud_firestore/cloud_firestore.dart';

class MiniProducts {
  final String id; // Changed from int to String
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  dynamic quantity; // This is likely for the cart, not Firestore

  MiniProducts({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
    this.quantity = 1,
  });

  // Factory constructor to create a MiniProducts from a Firestore DocumentSnapshot
  factory MiniProducts.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    // Safely get the data from the document, else empty Map
    final data = doc.data() ?? {};

    // Extract the rating Map and convert it to a Rating object
    final ratingData = data['rating'] as Map<String, dynamic>?;
    Rating? rating;
    if (ratingData != null) {
      rating = Rating(
        rate:
            (ratingData['rate'] as num?)?.toDouble() ??
            0.0, // Handle null/type conversion
        count: (ratingData['count'] as int?) ?? 0,
      );
    }

    return MiniProducts(
      id: doc.id, // The document ID from Firestore
      title: data['title'] ?? '', // Provide default values if field is missing
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      rating: rating,
    );
  }

  // Convert a MiniProducts object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {
        // Store the Rating object as a Map
        'rate': rating?.rate,
        'count': rating?.count,
      },
    };
  }

  // Updated copyWith to use String id
  MiniProducts copyWith({
    String? id,
    String? name,
    dynamic price,
    String? imageUrl,
    int? quantity,
  }) {
    return MiniProducts(
      id: id ?? this.id, // Now uses String id
      title: name ?? this.title,
      price: price ?? this.price,
      image: imageUrl ?? this.image,
      quantity: quantity ?? this.quantity,
      description: description,
      category: category,
      rating: rating,
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  // fromJson can be kept if you still need it for other purposes
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}
