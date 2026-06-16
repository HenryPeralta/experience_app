import 'package:experience_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetTotalOnboardingScreens {
  final OnboardingRepository repository;

  GetTotalOnboardingScreens(this.repository);

  Future<int> call() async {
    return await repository.getTotalScreens();
  }
}
