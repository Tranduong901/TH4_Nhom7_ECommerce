import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _error = '';

  // Pagination
  int _currentLimit = 10;
  final int _limitStep = 10;

  // Categories
  List<String> _categories = [];
  bool _isLoadingCategories = false;

  // Banners
  final List<String> _banners = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3', // Sale
    'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3', // Electronics
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3', // Fashion
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3', // Shoes
  ];

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get error => _error;
  List<String> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  List<String> get banners => _banners;

  ProductProvider() {
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchCategories(),
      fetchProducts(refresh: true),
    ]);
  }

  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    notifyListeners();
    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentLimit = _limitStep;
      _hasMore = true;
      _error = '';
      _products.clear();
    }

    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _apiService.getProducts(limit: _currentLimit);

      // FakeStore API returns maximum 20 items.
      if (newProducts.length <= _products.length) {
        _hasMore = false;
      } else {
        _products = newProducts;
        _currentLimit += _limitStep;
      }
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Product getProductById(int id) {
    return _products.firstWhere((prod) => prod.id == id);
  }
}
