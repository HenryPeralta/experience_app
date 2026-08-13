import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:experience_app/features/core/data/datasources/firebase_messaging_data_source.dart';
import 'package:experience_app/features/core/data/repositories/push_notification_repository.dart';
import 'package:experience_app/features/core/domain/usecases/push_notification_use_cases.dart';
import 'package:experience_app/features/core/domain/usecases/save_device_token_use_case.dart';

// Providers para inyección de dependencias

// Firebase Messaging instance
final firebaseMessagingProvider = Provider<FirebaseMessaging>((_) {
  return FirebaseMessaging.instance;
});

// Firestore instance
final firestoreProvider = Provider<FirebaseFirestore>((_) {
  return FirebaseFirestore.instance;
});

// Firebase Auth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((_) {
  return FirebaseAuth.instance;
});

// Auth State Changes Stream
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

// Data Source
final firebaseMessagingDataSourceProvider = Provider<FirebaseMessagingDataSource>((ref) {
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  return FirebaseMessagingDataSourceImpl(firebaseMessaging: firebaseMessaging);
});

// Repository
final pushNotificationRepositoryProvider = Provider<PushNotificationRepository>((ref) {
  final dataSource = ref.watch(firebaseMessagingDataSourceProvider);
  return PushNotificationRepositoryImpl(dataSource: dataSource);
});

// UseCases
final initializePushNotificationProvider = Provider<InitializePushNotificationUseCase>((ref) {
  final repository = ref.watch(pushNotificationRepositoryProvider);
  return InitializePushNotificationUseCaseImpl(repository: repository);
});

final getDeviceTokenProvider = Provider<GetDeviceTokenUseCase>((ref) {
  final repository = ref.watch(pushNotificationRepositoryProvider);
  return GetDeviceTokenUseCaseImpl(repository: repository);
});

final saveDeviceTokenProvider = Provider<SaveDeviceTokenUseCase>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return SaveDeviceTokenUseCaseImpl(firestore: firestore, auth: auth);
});

final listenForegroundMessagesProvider = StreamProvider.autoDispose<RemoteMessage>((ref) {
  final repository = ref.watch(pushNotificationRepositoryProvider);
  return repository.onMessageStream;
});

// Estado para controlar la inicialización
final pushNotificationInitializedProvider = FutureProvider<void>((ref) async {
  final useCase = ref.watch(initializePushNotificationProvider);
  await useCase();
});
