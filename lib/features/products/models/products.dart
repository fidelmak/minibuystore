class MiniProducts {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  dynamic quantity;

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

  factory MiniProducts.fromJson(Map<String, dynamic> json) {
    return MiniProducts(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {'title': title, 'price': price, 'description': description};
  }

  MiniProducts copyWith({
    String? id,
    String? name,
    dynamic price,
    String? imageUrl,
    int? quantity,
  }) {
    return MiniProducts(
      id: int.parse(id ?? this.id.toString()),
      title: name ?? this.title,
      price: price ?? this.price,
      image: imageUrl ?? this.image,
      quantity: quantity ?? this.quantity,
      description: this.description,
      category: this.category,
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(rate: json['rate'].toDouble(), count: json['count']);
  }
}
