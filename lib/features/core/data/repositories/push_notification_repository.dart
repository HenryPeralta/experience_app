import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:experience_app/features/core/data/datasources/firebase_messaging_data_source.dart';

abstract class PushNotificationRepository {
  Future<void> initialize();
  Future<String?> getDeviceToken();
  Future<void> requestNotificationPermission();
  Stream<RemoteMessage> get onMessageStream;
}

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final FirebaseMessagingDataSource _dataSource;

  PushNotificationRepositoryImpl({
    required FirebaseMessagingDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<void> initialize() => _dataSource.initialize();

  @override
  Future<String?> getDeviceToken() => _dataSource.getDeviceToken();

  @override
  Future<void> requestNotificationPermission() => 
      _dataSource.requestNotificationPermission();

  @override
  Stream<RemoteMessage> get onMessageStream => _dataSource.onMessageStream;
}
