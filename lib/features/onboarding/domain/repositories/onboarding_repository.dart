import 'package:experience_app/features/onboarding/domain/entities/onboarding.dart';

abstract class OnboardingRepository {
  /// Get all onboarding screens
  Future<List<Onboarding>> getOnboardingScreens();

  /// Get total onboarding screens
  Future<int> getTotalScreens();
}
