import 'dart:convert';

import 'package:minibuy/config/app_config.dart';
import 'package:minibuy/features/products/models/products.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = "https://fakestoreapi.com/products";
  Future<List<MiniProducts>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map((productJson) => MiniProducts.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<MiniProducts> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return MiniProducts.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load product with id $id");
    }
  }

  Future<List<MiniProducts>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$category'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map((productJson) => MiniProducts.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to load products for category $category");
    }
  }

  Future<List<MiniProducts>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map((productJson) => MiniProducts.fromJson(productJson))
          .toList();
    } else {
      throw Exception("Failed to search products with query $query");
    }
  }

  Future<List<String>> allCategory() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((category) => category.toString()).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
