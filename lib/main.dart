import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'package:experience_app/features/auth/presentation/views/login_view.dart';
import 'package:experience_app/features/core/data/datasources/firebase_messaging_data_source.dart';
import 'package:experience_app/features/core/data/services/local_notification_service.dart';
import 'package:experience_app/features/core/presentation/providers/push_notification_providers.dart';

// Variables globales para acceso desde handlers
late LocalNotificationService _localNotificationService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar servicio de notificaciones locales
  _localNotificationService = LocalNotificationServiceImpl();
  await _localNotificationService.initialize();

  // Configurar handler para mensajes en background (IMPORTANTE: debe ser antes de runApp)
  final dataSource = FirebaseMessagingDataSourceImpl(
    firebaseMessaging: FirebaseMessaging.instance,
  );
  dataSource.setOnBackgroundMessageHandler();

  // Solicitar permisos de notificación y obtener token
  await dataSource.requestNotificationPermission();
  
  // Obtener token (se guardará en Firestore cuando el usuario esté autenticado)
  final token = await dataSource.getDeviceToken();
  if (token != null) {
    debugPrint('📱 Device Token obtenido: $token');
  }

  runApp(
    ProviderScope(
      child: MyApp(localNotificationService: _localNotificationService),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final LocalNotificationService localNotificationService;

  const MyApp({
    super.key,
    required this.localNotificationService,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listener para guardar token cuando usuario se autentica
    ref.listen<AsyncValue<User?>>(
      authStateChangesProvider,
      (previous, next) {
        next.whenData((user) async {
          if (user != null) {
            debugPrint('👤 User authenticated: ${user.email}');
            
            // Obtener y guardar token en Firestore
            final getTokenUseCase = ref.read(getDeviceTokenProvider);
            final saveTokenUseCase = ref.read(saveDeviceTokenProvider);
            
            try {
              final token = await getTokenUseCase();
              if (token != null) {
                await saveTokenUseCase(token);
              }
            } catch (e) {
              debugPrint('❌ Error saving device token: $e');
            }
          }
        });
      },
    );

    // Inicializar push notifications
    ref.listen<AsyncValue<void>>(
      pushNotificationInitializedProvider,
      (previous, next) {
        next.whenData((_) {
          debugPrint('✅ Push notifications initialized');
        });
      },
    );

    // Escuchar mensajes en foreground
    ref.listen<AsyncValue<RemoteMessage>>(
      listenForegroundMessagesProvider,
      (previous, next) {
        next.whenData((message) {
          debugPrint('🔔 Foreground message: ${message.messageId}');
          
          // Mostrar notificación local
          final notification = message.notification;
          if (notification != null) {
            localNotificationService.showNotification(
              id: message.messageId.hashCode,
              title: notification.title ?? 'Notificación',
              body: notification.body ?? '',
              payload: message.data.toString(),
            );
          }
        });
      },
    );

    return MaterialApp(
      title: 'Experience App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      // Pantalla inicial para pruebas
      home: const LoginView(),
    );
  }
}