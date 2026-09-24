import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:experience_app/features/auth/presentation/views/login_view.dart';
import 'package:experience_app/features/core/data/services/notifications_service.dart';
import 'package:experience_app/features/ecommerce/presentation/views/order_detail_view.dart';

// Global key para la navegación desde notificaciones
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar servicio de notificaciones (Firebase + Local)
  await NotificationsService.instance.init();

  // Configurar callback para cuando se toque una notificación de orden
  NotificationsService.onOrderNotificationTapped = (orderId) {
    _navigateToOrderDetail(orderId);
  };

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Navega al detalle de la orden cuando se toca una notificación
void _navigateToOrderDetail(String orderId) {
  debugPrint('🔗 Deep Link: Navegando a orden $orderId');
  
  final currentUser = FirebaseAuth.instance.currentUser;
  
  // Si el usuario NO está autenticado, guardar orderId para después del login
  if (currentUser == null) {
    debugPrint('⚠️ Usuario no autenticado. Guardando orderId pendiente: $orderId');
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('pending_order_id', orderId);
      debugPrint('✅ OrderId guardado en SharedPreferences');
    });
    return;
  }
  
  // Si el usuario ESTÁ autenticado, navegar directo al detalle
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => OrderDetailView(orderId: orderId),
    ),
    (route) => route.isFirst, // Mantener el stack pero remover todo excepto el home
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Experience App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      // Global key para navegación desde notificaciones
      navigatorKey: navigatorKey,

      // Pantalla inicial para pruebas
      home: const LoginView(),
    );
  }
}