import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationsService {
  static final instance = NotificationsService();

  // Callback que se ejecuta cuando se toca una notificación desde background
  static Function(String orderId)? onOrderNotificationTapped;

  NotificationsService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin(),
        _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Future<void> init() async {
    debugPrint('🔔 Inicializando Notifications Service...');
    await _requestPermissions();
    await _initRemoteNotifications();
    await _initLocalNotifications();
    
    // Guardar token inicial cuando se autentica
    _firebaseAuth.authStateChanges().listen((_) => _saveCurrentToken());
    
    debugPrint('✅ Notifications Service inicializado');
  }

  /// Solicita permisos de notificación al usuario
  Future<void> _requestPermissions() async {
    try {
      final actualSettings = await _firebaseMessaging.getNotificationSettings();
      debugPrint(
        '📱 Estado actual de notificaciones: ${actualSettings.authorizationStatus}',
      );

      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      debugPrint('📱 Permisos de notificación solicitados: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('❌ Error solicitando permisos: $e');
    }
  }

  /// Inicializa Firebase Cloud Messaging (notificaciones remotas)
  Future<void> _initRemoteNotifications() async {
    try {
      // Obtener token inicial
      final token = await _firebaseMessaging.getToken();
      debugPrint('🔑 FCM Token: $token');
      await _saveToken(token);

      // Escuchar cambios de token
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('🔄 Token FCM renovado: $newToken');
        _saveToken(newToken);
      });

      // Escuchar mensajes en foreground
      FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);

      // Escuchar cuando se toca una notificación desde background/closed
      FirebaseMessaging.onMessageOpenedApp.listen(_notificationTappedHandler);

      debugPrint('✅ Firebase Messaging inicializado');
    } catch (e) {
      debugPrint('❌ Error inicializando Firebase Messaging: $e');
    }
  }

  /// Maneja cuando se toca una notificación desde background/closed
  void _notificationTappedHandler(RemoteMessage message) {
    try {
      debugPrint('📲 Notificación tocada desde background: ${message.messageId}');
      
      // Obtener el orderId del payload
      final orderId = message.data['sale_id'] ?? message.data['orderId'];
      
      if (orderId != null && orderId.isNotEmpty) {
        debugPrint('🎯 Navegando al detalle de orden: $orderId');
        // Llamar al callback si está definido
        onOrderNotificationTapped?.call(orderId);
      } else {
        debugPrint('⚠️ No se encontró orderId en el payload');
      }
    } catch (e) {
      debugPrint('❌ Error manejando notificación tocada: $e');
    }
  }

  /// Inicializa notificaciones locales
  Future<void> _initLocalNotifications() async {
    try {
      // Configuración para Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración para iOS
      const iosSettings = DarwinInitializationSettings();

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('📲 Notificación local tocada: ${response.payload}');
          
          // Si hay payload (orderId), navegar al detalle
          final orderId = response.payload;
          if (orderId != null && orderId.isNotEmpty) {
            debugPrint('🎯 Navegando al detalle de orden desde notificación local: $orderId');
            onOrderNotificationTapped?.call(orderId);
          }
        },
      );

      // Crear canal de notificación para Android
      await _createAndroidNotificationChannel();

      debugPrint('✅ Notificaciones locales inicializadas');
    } catch (e) {
      debugPrint('❌ Error inicializando notificaciones locales: $e');
    }
  }

  /// Crea canal de notificación para Android
  Future<void> _createAndroidNotificationChannel() async {
    try {
      const androidChannel = AndroidNotificationChannel(
        'canal_alta_prioridad',
        'Avisos importantes',
        description: 'Canal para notificaciones de alta prioridad',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      debugPrint('✅ Canal de Android creado');
    } catch (e) {
      debugPrint('❌ Error creando canal Android: $e');
    }
  }

  /// Guarda el token FCM actual en Firestore si el usuario está autenticado
  Future<void> _saveCurrentToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      await _saveToken(token);
    } catch (e) {
      debugPrint('❌ Error guardando token actual: $e');
    }
  }

  /// Guarda el token en Firestore bajo el documento del usuario
  Future<void> _saveToken(String? token) async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      
      if (uid == null || token == null || token.isEmpty) {
        debugPrint('⚠️ No se puede guardar token: uid=$uid, token=$token');
        return;
      }

      await _firestore.collection('users').doc(uid).set({
        'deviceToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Token guardado en Firestore para usuario $uid');
    } catch (e) {
      debugPrint('❌ Error guardando token en Firestore: $e');
    }
  }

  /// Maneja mensajes que llegan en foreground
  void _foregroundMessageHandler(RemoteMessage message) {
    try {
      debugPrint('📬 Mensaje en foreground recibido');
      
      if (message.notification != null) {
        debugPrint(
          '📢 Título: ${message.notification!.title}, Cuerpo: ${message.notification!.body}',
        );
        
        // Mostrar notificación local
        _showLocalNotification(
          title: message.notification!.title ?? 'Notificación',
          body: message.notification!.body ?? '',
          payload: message.data['sale_id'],
        );
      }
    } catch (e) {
      debugPrint('❌ Error manejando mensaje en foreground: $e');
    }
  }

  /// Muestra una notificación local
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'canal_alta_prioridad',
        'Avisos importantes',
        channelDescription: 'Canal para notificaciones de alta prioridad',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails();

      const platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: payload,
      );

      debugPrint('✅ Notificación local mostrada: $title');
    } catch (e) {
      debugPrint('❌ Error mostrando notificación local: $e');
    }
  }

  /// Muestra una notificación de compra confirmada
  Future<void> showOrderConfirmedNotification({
    required String orderId,
    required double total,
  }) async {
    await _showLocalNotification(
      title: 'Compra confirmada ✅',
      body: 'Tu compra por \$${total.toStringAsFixed(2)} ha sido procesada',
      payload: orderId,
    );
  }

  /// Método público para mostrar notificaciones locales
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'canal_alta_prioridad',
        'Avisos importantes',
        channelDescription: 'Canal para notificaciones de alta prioridad',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails();

      const platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: payload,
      );

      debugPrint('✅ Notificación local mostrada: $title');
    } catch (e) {
      debugPrint('❌ Error mostrando notificación local: $e');
    }
  }
}
