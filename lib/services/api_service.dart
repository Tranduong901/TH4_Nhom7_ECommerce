import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/products';
  static const Map<String, String> _categoryMapVi = {
    'beauty': 'Làm đẹp',
    'fragrances': 'Nước hoa',
    'furniture': 'Nội thất',
    'groceries': 'Tạp hóa',
    'home-decoration': 'Trang trí nhà cửa',
    'kitchen-accessories': 'Phụ kiện nhà bếp',
    'laptops': 'Máy tính xách tay',
    'mens-shirts': 'Áo nam',
    'mens-shoes': 'Giày nam',
    'mens-watches': 'Đồng hồ nam',
    'mobile-accessories': 'Phụ kiện di động',
    'motorcycle': 'Xe mô tô',
    'skin-care': 'Chăm sóc da',
    'smartphones': 'Điện thoại thông minh',
    'sports-accessories': 'Phụ kiện thể thao',
    'sunglasses': 'Kính mát',
    'tablets': 'Máy tính bảng',
    'tops': 'Áo kiểu',
    'vehicle': 'Phương tiện',
    'womens-bags': 'Túi xách nữ',
    'womens-dresses': 'Váy nữ',
    'womens-jewellery': 'Trang sức nữ',
    'womens-shoes': 'Giày nữ',
    'womens-watches': 'Đồng hồ nữ',
  };

  static const Map<String, String> _productTitleMapVi = {
    'Essence Mascara Lash Princess': 'Mascara Essence Lash Princess',
    'Eyeshadow Palette with Mirror': 'Bảng phấn mắt kèm gương',
    'Powder Canister': 'Hộp phấn phủ',
    'Red Lipstick': 'Son môi đỏ',
    'Red Nail Polish': 'Sơn móng đỏ',
    'Calvin Klein CK One': 'Nước hoa Calvin Klein CK One',
    'Chanel Coco Noir Eau De': 'Nước hoa Chanel Coco Noir Eau De',
    "Dior J'adore": "Nước hoa Dior J'adore",
    'Dolce Shine Eau de': 'Nước hoa Dolce Shine Eau de',
    'Gucci Bloom Eau de': 'Nước hoa Gucci Bloom Eau de',
    'Annibale Colombo Bed': 'Giường Annibale Colombo',
    'Annibale Colombo Sofa': 'Ghế sofa Annibale Colombo',
    'Bedside Table African Cherry': 'Tủ đầu giường gỗ anh đào',
    'Knoll Saarinen Executive Conference Chair': 'Ghế hội nghị Knoll Saarinen',
    'Wooden Bathroom Sink With Mirror': 'Bồn rửa gỗ kèm gương',
    'Apple': 'Táo',
    'Beef Steak': 'Bò bít tết',
    'Cat Food': 'Thức ăn cho mèo',
    'Chicken Meat': 'Thịt gà',
    'Cooking Oil': 'Dầu ăn',
    'Cucumber': 'Dưa leo',
    'Dog Food': 'Thức ăn cho chó',
    'Eggs': 'Trứng',
    'Fish Steak': 'Cá phi lê',
    'Green Bell Pepper': 'Ớt chuông xanh',
    'Green Chili Pepper': 'Ớt xanh cay',
    'Honey Jar': 'Hũ mật ong',
    'Ice Cream': 'Kem',
    'Juice': 'Nước ép',
    'Kiwi': 'Kiwi',
    'Lemon': 'Chanh',
    'Milk': 'Sữa',
    'Mulberry': 'Dâu tằm',
    'Nescafe Coffee': 'Cà phê Nescafe',
    'Potatoes': 'Khoai tây',
    'Protein Powder': 'Bột protein',
    'Red Onions': 'Hành tím',
    'Rice': 'Gạo',
    'Soft Drinks': 'Nước ngọt',
    'Strawberry': 'Dâu tây',
    'Tissue Paper Box': 'Hộp giấy ăn',
    'Water': 'Nước lọc',
    'Decoration Swing': 'Xích đu trang trí',
    'Family Tree Photo Frame': 'Khung ảnh cây gia đình',
    'House Showpiece Plant': 'Cây trang trí để bàn',
    'Plant Pot': 'Chậu cây',
    'Table Lamp': 'Đèn bàn',
    'Bamboo Spatula': 'Xẻng tre',
    'Black Aluminium Cup': 'Cốc nhôm đen',
    'Black Whisk': 'Phới lồng đen',
    'Boxed Blender': 'Máy xay hộp',
    'Carbon Steel Wok': 'Chảo wok thép carbon',
    'Chopping Board': 'Thớt',
    'Citrus Squeezer Yellow': 'Dụng cụ vắt cam vàng',
    'Egg Slicer': 'Dụng cụ cắt trứng',
    'Electric Stove': 'Bếp điện',
    'Fine Mesh Strainer': 'Rây lưới mịn',
    'Fork': 'Nĩa',
    'Glass': 'Ly thủy tinh',
    'Grater Black': 'Dụng cụ bào đen',
    'Hand Blender': 'Máy xay cầm tay',
    'Ice Cube Tray': 'Khay đá',
    'Kitchen Sieve': 'Rây bếp',
    'Knife': 'Dao',
    'Lunch Box': 'Hộp cơm',
    'Microwave Oven': 'Lò vi sóng',
    'Mug Tree Stand': 'Giá treo cốc',
    'Pan': 'Chảo',
    'Plate': 'Đĩa',
    'Red Tongs': 'Kẹp gắp đỏ',
    'Silver Pot With Glass Cap': 'Nồi bạc kèm nắp kính',
    'Slotted Turner': 'Xẻng lật có rãnh',
    'Spice Rack': 'Kệ gia vị',
    'Spoon': 'Muỗng',
    'Tray': 'Khay',
    'Wooden Rolling Pin': 'Cây cán bột gỗ',
    'Yellow Peeler': 'Dao bào vàng',
    'Apple MacBook Pro 14 Inch Space Grey': 'MacBook Pro 14 inch xám',
    'Asus Zenbook Pro Dual Screen Laptop':
        'Laptop Asus Zenbook Pro hai màn hình',
    'Huawei Matebook X Pro': 'Huawei Matebook X Pro',
    'Lenovo Yoga 920': 'Lenovo Yoga 920',
    'New DELL XPS 13 9300 Laptop': 'Laptop DELL XPS 13 9300',
    'Blue & Black Check Shirt': 'Áo sơ mi caro xanh đen',
    'Gigabyte Aorus Men Tshirt': 'Áo thun nam Gigabyte Aorus',
    'Man Plaid Shirt': 'Áo sơ mi nam caro',
    'Man Short Sleeve Shirt': 'Áo sơ mi nam tay ngắn',
    'Men Check Shirt': 'Áo sơ mi nam họa tiết caro',
    'Nike Air Jordan 1 Red And Black': 'Giày Nike Air Jordan 1 đỏ đen',
    'Nike Baseball Cleats': 'Giày đinh bóng chày Nike',
    'Puma Future Rider Trainers': 'Giày Puma Future Rider',
    'Sports Sneakers Off White & Red': 'Giày thể thao trắng đỏ Off White',
    'Sports Sneakers Off White Red': 'Giày thể thao Off White đỏ trắng',
    'Brown Leather Belt Watch': 'Đồng hồ dây da nâu',
    'Longines Master Collection': 'Đồng hồ Longines Master Collection',
    'Rolex Cellini Date Black Dial': 'Rolex Cellini Date mặt đen',
    'Rolex Cellini Moonphase': 'Rolex Cellini Moonphase',
    'Rolex Datejust': 'Rolex Datejust',
    'Rolex Submariner Watch': 'Đồng hồ Rolex Submariner',
    'Amazon Echo Plus': 'Loa thông minh Amazon Echo Plus',
    'Apple Airpods': 'Tai nghe Apple AirPods',
  };

  String mapCategoryToVietnamese(String category) {
    final key = category.trim().toLowerCase();
    return _categoryMapVi[key] ?? category;
  }

  String mapProductTitleToVietnamese(String title) {
    return _productTitleMapVi[title.trim()] ?? title;
  }

  Map<String, dynamic> _mapProductJson(Map<String, dynamic> input) {
    final json = Map<String, dynamic>.from(input);
    json['category'] = mapCategoryToVietnamese(
      (json['category'] ?? '').toString(),
    );
    json['title'] = mapProductTitleToVietnamese(
      (json['title'] ?? '').toString(),
    );
    return json;
  }

  Future<List<Product>> fetchProductsPage({
    int limit = 20,
    int skip = 0,
  }) async {
    final uri = Uri.parse('$_baseUrl?limit=$limit&skip=$skip');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Không thể tải sản phẩm: ${response.statusCode}');
    }

    final Map<String, dynamic> payload =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> data = payload['products'] as List<dynamic>;

    return data
        .map((item) => _mapProductJson(item as Map<String, dynamic>))
        .map(Product.fromJson)
        .toList();
  }

  Future<List<Product>> fetchProducts() {
    return fetchProductsPage(limit: 100, skip: 0);
  }
}
