import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../ecommerce/domain/entities/product.dart';

abstract class FirestoreProductDataSource {
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<Product> getProduct(String productId);
  Future<List<Product>> getAdminProducts(String adminId);
}

class FirestoreProductDataSourceImpl implements FirestoreProductDataSource {
  final FirebaseFirestore firestore;

  FirestoreProductDataSourceImpl({required this.firestore});

  @override
  Future<void> createProduct(Product product) async {
    await firestore.collection('products').doc(product.id).set({
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.image,
      'sizes': product.sizes,
      'colors': product.colors,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateProduct(Product product) async {
    await firestore.collection('products').doc(product.id).update({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.image,
      'sizes': product.sizes,
      'colors': product.colors,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  }

  @override
  Future<Product> getProduct(String productId) async {
    final doc = await firestore.collection('products').doc(productId).get();
    if (!doc.exists) throw Exception('Producto no encontrado');
    return Product.fromMap(doc.data() ?? {});
  }

  @override
  Future<List<Product>> getAdminProducts(String adminId) async {
    final snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }
}
