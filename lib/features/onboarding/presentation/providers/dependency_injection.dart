import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/features/onboarding/data/datasources/interest_data_source.dart';
import 'package:experience_app/features/onboarding/data/datasources/local_interest_data_source.dart';
import 'package:experience_app/features/onboarding/data/datasources/local_onboarding_data_source.dart';
import 'package:experience_app/features/onboarding/data/datasources/onboarding_data_source.dart';
import 'package:experience_app/features/onboarding/data/repositories/interest_repository_impl.dart';
import 'package:experience_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:experience_app/features/onboarding/domain/repositories/interest_repository.dart';
import 'package:experience_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:experience_app/features/onboarding/domain/usecases/get_all_interests.dart';
import 'package:experience_app/features/onboarding/domain/usecases/get_onboarding_screens.dart';
import 'package:experience_app/features/onboarding/domain/usecases/get_total_onboarding_screens.dart';
import 'package:experience_app/features/onboarding/domain/usecases/save_selected_interests.dart';

// ========== DataSources ==========
final onboardingDataSourceProvider = Provider<OnboardingDataSource>((ref) {
  return LocalOnboardingDataSource();
});

final interestDataSourceProvider = Provider<InterestDataSource>((ref) {
  return LocalInterestDataSource();
});

// ========== Repositories ==========
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final dataSource = ref.watch(onboardingDataSourceProvider);
  return OnboardingRepositoryImpl(dataSource: dataSource);
});

final interestRepositoryProvider = Provider<InterestRepository>((ref) {
  final dataSource = ref.watch(interestDataSourceProvider);
  return InterestRepositoryImpl(dataSource: dataSource);
});

// ========== UseCases ==========
final getOnboardingScreensProvider = Provider<GetOnboardingScreens>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return GetOnboardingScreens(repository);
});

final getTotalOnboardingScreensProvider = Provider<GetTotalOnboardingScreens>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return GetTotalOnboardingScreens(repository);
});

final getAllInterestsProvider = Provider<GetAllInterests>((ref) {
  final repository = ref.watch(interestRepositoryProvider);
  return GetAllInterests(repository);
});

final saveSelectedInterestsProvider = Provider<SaveSelectedInterests>((ref) {
  final repository = ref.watch(interestRepositoryProvider);
  return SaveSelectedInterests(repository);
});
