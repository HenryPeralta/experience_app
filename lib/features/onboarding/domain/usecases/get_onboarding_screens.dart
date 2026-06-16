import 'package:experience_app/features/onboarding/domain/entities/onboarding.dart';
import 'package:experience_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingScreens {
  final OnboardingRepository repository;

  GetOnboardingScreens(this.repository);

  Future<List<Onboarding>> call() async {
    return await repository.getOnboardingScreens();
  }
}
