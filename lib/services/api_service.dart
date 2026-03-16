import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts({int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products?limit=$limit'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/categories'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.cast<String>();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products for category');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
