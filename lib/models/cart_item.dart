import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size;
  String color;
  bool isSelected;
  DateTime addedAt; // when item was added or last updated in cart

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size = 'M',
    this.color = 'Default',
    this.isSelected = true,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'size': size,
    'color': color,
    'isSelected': isSelected,
    'addedAt': addedAt.millisecondsSinceEpoch,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final at = json['addedAt'];
    DateTime parsedAt;
    if (at == null) {
      parsedAt = DateTime.now();
    } else if (at is int) {
      parsedAt = DateTime.fromMillisecondsSinceEpoch(at);
    } else if (at is String) {
      // try parse ISO string
      parsedAt = DateTime.tryParse(at) ?? DateTime.now();
    } else {
      parsedAt = DateTime.now();
    }

    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? 'M',
      color: json['color'] ?? 'Default',
      isSelected: json['isSelected'] ?? true,
      addedAt: parsedAt,
    );
  }
}
