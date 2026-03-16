import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<CartItem> get selectedItems =>
      List.unmodifiable(_items.where((item) => item.isSelected));

  bool get areAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  bool get hasSelectedItems => _items.any((item) => item.isSelected);

  bool get hasItems => _items.isNotEmpty;

  bool? get selectAllValue {
    if (_items.isEmpty) {
      return false;
    }

    final bool allSelected = _items.every((item) => item.isSelected);
    if (allSelected) {
      return true;
    }

    final bool noneSelected = _items.every((item) => !item.isSelected);
    if (noneSelected) {
      return false;
    }

    return null;
  }

  int get totalItemCount =>
      _items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get itemCount => totalItemCount;

  void addItem(Product product) {
    final int existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    final int existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      return;
    }

    _items[existingIndex].quantity++;
    notifyListeners();
  }

  void decrementQuantity(Product product) {
    final int existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      return;
    }

    if (_items[existingIndex].quantity > 1) {
      _items[existingIndex].quantity--;
    } else {
      _items.removeAt(existingIndex);
    }

    notifyListeners();
  }

  double get totalAmount {
    return _items
        .where((item) => item.isSelected)
        .fold<double>(
          0,
          (sum, item) => sum + item.product.price * item.quantity,
        );
  }

  void toggleItemSelection(Product product, bool value) {
    final int existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      return;
    }

    _items[existingIndex].isSelected = value;
    notifyListeners();
  }

  void toggleAll(bool value) {
    for (final item in _items) {
      item.isSelected = value;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
