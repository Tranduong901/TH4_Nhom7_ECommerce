import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  /// Get all orders
  List<Order> getAllOrders() => _orders;

  /// Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  /// Add new order
  void addOrder(Order order) {
    _orders.insert(0, order); // Newest first
    notifyListeners();
  }

  /// Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  /// Remove order by ID
  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }

  /// Cancel order (change status to 'Đã hủy')
  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, 'Đã hủy');
  }

  /// Clear all orders
  void clearAllOrders() {
    _orders.clear();
    notifyListeners();
  }

  /// Get total number of orders
  int get totalOrders => _orders.length;

  /// Get count by status
  int getCountByStatus(String status) {
    return _orders.where((order) => order.status == status).length;
  }
}
