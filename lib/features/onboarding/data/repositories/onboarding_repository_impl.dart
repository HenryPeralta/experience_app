import 'package:experience_app/features/onboarding/domain/entities/onboarding.dart';
import 'package:experience_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:experience_app/features/onboarding/data/datasources/onboarding_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingDataSource dataSource;

  OnboardingRepositoryImpl({required this.dataSource});

  @override
  Future<List<Onboarding>> getOnboardingScreens() async {
    try {
      return await dataSource.getOnboardingScreens();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getTotalScreens() async {
    try {
      return await dataSource.getTotalScreens();
    } catch (e) {
      rethrow;
    }
  }
}
