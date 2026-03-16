class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}
