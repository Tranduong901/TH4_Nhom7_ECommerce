import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/local_storage_service.dart';

class CartProvider with ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  List<CartItem> _items = [];
  bool _isLoading = true;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get cartCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      if (item.isSelected) {
        total += item.product.price * item.quantity;
      }
    }
    return total;
  }

  bool get isSelectAll =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _isLoading = true;
    notifyListeners();
    _items = await _storageService.loadCart();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCart() async {
    await _storageService.saveCart(_items);
    notifyListeners();
  }

  void addToCart(Product product, String size, String color, int quantity) {
    int index = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.size == size &&
        item.color == color);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
          product: product,
          size: size,
          color: color,
          quantity: quantity,
          isSelected: true));
    }
    _saveCart();
  }

  void updateQuantity(int index, int delta) {
    _items[index].quantity += delta;
    if (_items[index].quantity < 1) _items[index].quantity = 1;
    _saveCart();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _saveCart();
  }

  void toggleItemSelection(int index) {
    _items[index].isSelected = !_items[index].isSelected;
    _saveCart();
  }

  void toggleSelectAll(bool value) {
    for (var item in _items) {
      // Don't change if the items are already in correct checkout state
      item.isSelected = value;
    }
    _saveCart();
  }

  void clearSelectedItems() {
    _items.removeWhere((item) => item.isSelected);
    _saveCart();
  }
}
