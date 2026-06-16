import 'package:experience_app/features/onboarding/domain/entities/onboarding.dart';
import 'onboarding_data_source.dart';

class LocalOnboardingDataSource implements OnboardingDataSource {
  static const List<Onboarding> _mockOnboardingScreens = [
    Onboarding(
      title: 'Welcome',
      subtitle: 'Discover amazing products',
      image: 'assets/onboarding.png',
    ),
    Onboarding(
      title: 'Easy Shopping',
      subtitle: 'Shop with just a few taps',
      image: 'assets/onboarding.png',
    ),
    Onboarding(
      title: 'Fast Delivery',
      subtitle: 'Get your items delivered quickly',
      image: 'assets/onboarding.png',
    ),
  ];

  @override
  Future<List<Onboarding>> getOnboardingScreens() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockOnboardingScreens;
  }

  @override
  Future<int> getTotalScreens() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockOnboardingScreens.length;
  }
}
