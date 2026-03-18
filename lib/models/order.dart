import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final String shippingAddress;
  final String paymentMethod; // 'COD' or 'MOMO'
  final String status; // 'Chờ xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy'
  final DateTime createdAt;
  final double totalAmount;

  Order({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
  });

  /// Calculate total from items
  factory Order.create({
    required List<CartItem> items,
    required String shippingAddress,
    required String paymentMethod,
  }) {
    double total = 0.0;
    for (var item in items) {
      total += item.product.price * item.quantity;
    }

    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: 'Chờ xác nhận',
      createdAt: DateTime.now(),
      totalAmount: total,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((item) => item.toJson()).toList(),
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': status,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'totalAmount': totalAmount,
      };

  /// Create from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }

  /// Create a copy with modified fields
  Order copyWith({
    String? id,
    List<CartItem>? items,
    String? shippingAddress,
    String? paymentMethod,
    String? status,
    DateTime? createdAt,
    double? totalAmount,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
