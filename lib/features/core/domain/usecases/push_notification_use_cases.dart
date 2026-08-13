import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:experience_app/features/core/data/repositories/push_notification_repository.dart';

abstract class InitializePushNotificationUseCase {
  Future<void> call();
}

class InitializePushNotificationUseCaseImpl implements InitializePushNotificationUseCase {
  final PushNotificationRepository _repository;

  InitializePushNotificationUseCaseImpl({
    required PushNotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<void> call() async {
    await _repository.initialize();
  }
}

// UseCase para obtener el token del dispositivo
abstract class GetDeviceTokenUseCase {
  Future<String?> call();
}

class GetDeviceTokenUseCaseImpl implements GetDeviceTokenUseCase {
  final PushNotificationRepository _repository;

  GetDeviceTokenUseCaseImpl({
    required PushNotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<String?> call() => _repository.getDeviceToken();
}

// UseCase para escuchar mensajes en foreground
abstract class ListenForegroundMessagesUseCase {
  Stream<RemoteMessage> call();
}

class ListenForegroundMessagesUseCaseImpl implements ListenForegroundMessagesUseCase {
  final PushNotificationRepository _repository;

  ListenForegroundMessagesUseCaseImpl({
    required PushNotificationRepository repository,
  }) : _repository = repository;

  @override
  Stream<RemoteMessage> call() => _repository.onMessageStream;
}
