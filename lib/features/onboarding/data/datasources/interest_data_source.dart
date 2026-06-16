import 'package:experience_app/features/onboarding/domain/entities/interest.dart';

abstract class InterestDataSource {
  /// Get all available interests
  Future<List<Interest>> getAllInterests();

  /// Save selected interests to local storage
  Future<void> saveSelectedInterests(List<Interest> interests);

  /// Get saved interests from local storage
  Future<List<Interest>> getSavedInterests();
}
