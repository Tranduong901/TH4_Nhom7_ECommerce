import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  static const String _cartStorageKey = 'CART_DATA_JSON';
  List<CartItem> _items = [];
  bool _isLoading = true;

  // Expose the internal list which is maintained newest-first by add/load logic.
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
    loadCartFromLocal();
  }

  Future<void> loadCartFromLocal() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartStorageKey);
    if (raw == null || raw.isEmpty) {
      _items = [];
    } else {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _items = decoded
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();
      _items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveCartToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_cartStorageKey, jsonString);
  }

  Future<void> _saveCart() async {
    await saveCartToLocal();
    notifyListeners();
  }

  void addItem(Product product, String size, String color, int quantity) {
    addToCart(product, size, color, quantity);
  }

  void addToCart(Product product, String size, String color, int quantity) {
    int index = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.size == size &&
        item.color == color);
    if (index >= 0) {
      // existing item: increase quantity, update timestamp and move to front
      _items[index].quantity += quantity;
      _items[index].addedAt = DateTime.now();
      final updated = _items.removeAt(index);
      _items.insert(0, updated);
    } else {
      // new item: insert at front so newest shows up first
      _items.insert(
          0,
          CartItem(
              product: product,
              size: size,
              color: color,
              quantity: quantity,
              isSelected: true,
              addedAt: DateTime.now()));
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

  /// Remove item and return it (useful for undo operations)
  CartItem removeItemAt(int index) {
    final removed = _items.removeAt(index);
    _saveCart();
    return removed;
  }

  /// Insert an item at specific index (useful for undo)
  void insertItemAt(int index, CartItem item) {
    if (index < 0 || index > _items.length) {
      _items.insert(0, item);
    } else {
      _items.insert(index, item);
    }
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

  void removePurchasedItems(List<CartItem> purchasedItems) {
    for (final purchased in purchasedItems) {
      final index = _items.indexWhere((item) =>
          item.product.id == purchased.product.id &&
          item.size == purchased.size &&
          item.color == purchased.color &&
          item.addedAt.millisecondsSinceEpoch ==
              purchased.addedAt.millisecondsSinceEpoch);
      if (index >= 0) {
        _items.removeAt(index);
      }
    }
    _saveCart();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
  }
}
