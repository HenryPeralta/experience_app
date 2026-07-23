import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../ecommerce/domain/entities/product.dart';
import 'product_data_source.dart';

/// Adaptador que implementa ProductDataSource pero trae datos de Firestore
class FirestoreProductDataSourceAdapter implements ProductDataSource {
  final FirebaseFirestore firestore;

  FirestoreProductDataSourceAdapter({required this.firestore});

  @override
  Future<List<Product>> getAllProducts() async {
    final snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshot = await firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    final doc = await firestore.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return Product.fromMap(doc.data() ?? {});
  }
}
