import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageDataSource {
  Future<String> uploadProductImage(File imageFile, String productId);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageDataSourceImpl({required this.firebaseStorage});

  @override
  Future<String> uploadProductImage(File imageFile, String productId) async {
    try {
      // Crear referencia con estructura: products/{productId}/image
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}';
      final ref = firebaseStorage.ref().child('products/$productId/$fileName');

      // Subir archivo
      await ref.putFile(imageFile);

      // Obtener URL de descarga
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }
}
