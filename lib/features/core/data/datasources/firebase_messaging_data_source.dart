import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseMessagingDataSource {
  Future<void> initialize();
  Future<String?> getDeviceToken();
  Future<void> requestNotificationPermission();
  Stream<RemoteMessage> get onMessageStream;
  void setOnBackgroundMessageHandler();
}

class FirebaseMessagingDataSourceImpl implements FirebaseMessagingDataSource {
  final FirebaseMessaging _firebaseMessaging;

  FirebaseMessagingDataSourceImpl({required FirebaseMessaging firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging;

  @override
  Future<void> initialize() async {
    try {
      // Solicitar permisos (Android 13+)
      await requestNotificationPermission();
      
      // Obtener token del dispositivo
      final token = await _firebaseMessaging.getToken();
      debugPrint('🔔 FCM Token: $token');
      
      // Guardar token en Firestore (opcional, para enviar a usuarios específicos)
      // TODO: Guardar en Firestore
    } catch (e) {
      debugPrint('❌ Error initializing FCM: $e');
    }
  }

  @override
  Future<String?> getDeviceToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('❌ Error getting device token: $e');
      return null;
    }
  }

  @override
  Future<void> requestNotificationPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permission: AUTHORIZED');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('⚠️ Notification permission: PROVISIONAL');
      } else {
        debugPrint('❌ Notification permission: DENIED');
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
    }
  }

  @override
  Stream<RemoteMessage> get onMessageStream => 
      FirebaseMessaging.onMessage.asBroadcastStream();

  @override
  void setOnBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  }
}

// Handler para mensajes en background (isolate aparte)
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint('🔔 Background Message: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
  
  // Aquí puedes guardar en caché local o hacer algo con el mensaje
  // TODO: Manejar acciones en background
}
