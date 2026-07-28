📸 FIREBASE STORAGE INTEGRATION - RESUMEN
============================================

✅ INSTALADO:
  - firebase_storage: ^12.4.10 (compatible con firebase_core 3.15.2)
  - image_picker: ^1.0.0

✅ ARCHIVOS CREADOS:
  1. lib/features/admin/data/datasources/firebase_storage_data_source.dart
     - FirebaseStorageDataSource (interfaz)
     - FirebaseStorageDataSourceImpl (implementación)
     - Método: uploadProductImage(File, String productId) → String URL
  
  2. lib/features/admin/data/repositories/admin_storage_repository.dart
     - AdminStorageRepository (interfaz)
     - AdminStorageRepositoryImpl (implementación)
  
  3. lib/features/admin/domain/usecases/upload_product_image_use_case.dart
     - UploadProductImageUseCase (interfaz)
     - UploadProductImageUseCaseImpl (implementación)

✅ ACTUALIZACIONES:
  1. pubspec.yaml - Agregada dependencia firebase_storage
  2. lib/features/admin/presentation/providers/admin_providers.dart
     - firebaseStorageDataSourceProvider
     - adminStorageRepositoryProvider
     - uploadProductImageProvider
  
  3. lib/features/admin/presentation/views/add_product_view.dart
     - Eliminado campo _imageController (URL manual)
     - Agregado File? _selectedImage
     - Método _pickImage() para seleccionar imágenes
     - UI con preview y botón "Seleccionar Imagen"
     - En _submitForm(): sube imagen a Storage primero, luego guarda producto

🔧 FLUJO DE SUBIDA DE IMAGEN:
  1. Admin toca botón "Seleccionar Imagen"
  2. Se abre galería del dispositivo
  3. Selecciona imagen → muestra preview
  4. Admin completa resto del formulario
  5. Toca "Guardar Producto":
     a. Genera productId (UUID)
     b. Sube imagen a gs://experience-app-56e09.appspot.com/products/{productId}/image_{timestamp}
     c. Obtiene URL permanente de Storage
     d. Guarda producto en Firestore con imagen_url = Storage URL
     e. Muestra SnackBar de éxito
     f. Navega de vuelta al dashboard

🔐 NEXT STEP - FIREBASE CONSOLE:
  Ir a: https://console.firebase.google.com/u/0/project/experience-app-56e09/storage/rules
  
  Reemplazar el contenido con:
  
  rules_version = '2';
  service firebase.storage {
    match /b/{bucket}/o {
      // Solo admins pueden subir productos
      match /products/{productId}/{allPaths=**} {
        allow read: if request.auth != null;
        allow write: if request.auth != null && 
                        get(/databases/(default)/documents/users/$(request.auth.uid)).data.role == 'admin';
      }
    }
  }
  
  Luego hacer clic en "Publish"

📱 PRUEBA:
  1. Inicia app con rol admin (admin@gmail.com)
  2. Toca + azul en admin dashboard
  3. Toca "Seleccionar Imagen"
  4. Selecciona una imagen de tu galería
  5. Completa el formulario (título, precio, etc.)
  6. Toca "Guardar Producto"
  7. Verifica que la imagen aparece en el dashboard y en Firestore

✨ NOTA: Las imágenes se guardarán con URLs permanentes tipo:
  https://firebasestorage.googleapis.com/v0/b/experience-app-56e09.appspot.com/o/products%2F{productId}%2Fimage_{timestamp}?alt=media&token={token}
