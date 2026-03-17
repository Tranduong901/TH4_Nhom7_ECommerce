import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final CollectionReference _productsCol = FirebaseFirestore.instance.collection('products');

  // Lấy danh sách sản phẩm từ Firebase
  Future<List<Product>> getProducts() async {
    final snapshot = await _productsCol.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Đảm bảo ID được lấy từ document id nếu trong data không có
      return Product.fromJson({...data, 'id': int.tryParse(doc.id) ?? data['id']});
    }).toList();
  }

  // Hàm "thần thánh" để đẩy dữ liệu mẫu từ API lên Firebase cho nhóm dùng chung
  Future<void> seedDatabase(List<Product> products) async {
    final batch = FirebaseFirestore.instance.batch();
    for (var product in products) {
      final docRef = _productsCol.doc(product.id.toString());
      batch.set(docRef, {
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': product.image,
        'rating': {
          'rate': product.rating.rate,
          'count': product.rating.count,
        }
      });
    }
    await batch.commit();
  }
}
