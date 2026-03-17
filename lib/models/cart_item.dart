import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String size;
  String color;
  bool isSelected;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size = 'M',
    this.color = 'Default',
    this.isSelected = true,
  });

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'size': size,
    'color': color,
    'isSelected': isSelected,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: Product.fromJson(json['product']),
    quantity: json['quantity'],
    size: json['size'],
    color: json['color'],
    isSelected: json['isSelected'],
  );
}
