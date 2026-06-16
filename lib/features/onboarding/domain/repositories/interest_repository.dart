import 'package:experience_app/features/onboarding/domain/entities/interest.dart';

abstract class InterestRepository {
  /// Get all available interests
  Future<List<Interest>> getAllInterests();

  /// Save selected interests
  Future<void> saveSelectedInterests(List<Interest> interests);

  /// Get saved interests
  Future<List<Interest>> getSavedInterests();
}
