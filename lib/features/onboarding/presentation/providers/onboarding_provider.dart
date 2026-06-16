import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/onboarding/domain/entities/interest.dart';
import 'package:experience_app/features/onboarding/domain/entities/onboarding.dart';
import 'package:experience_app/features/onboarding/domain/usecases/get_all_interests.dart';
import 'package:experience_app/features/onboarding/domain/usecases/save_selected_interests.dart';
import 'dependency_injection.dart';

// Current page state
final onboardingPageProvider = StateProvider<int>((ref) => 0);

// Onboarding screens provider
final onboardingScreensProvider = FutureProvider<List<Onboarding>>((ref) async {
  final useCase = ref.watch(getOnboardingScreensProvider);
  return await useCase();
});

// Total screens provider
final totalScreensProvider = FutureProvider<int>((ref) async {
  final useCase = ref.watch(getTotalOnboardingScreensProvider);
  return await useCase();
});

// All interests provider
final allInterestsProvider = FutureProvider<List<Interest>>((ref) async {
  final useCase = ref.watch(getAllInterestsProvider);
  return await useCase();
});

// StateNotifier for interests management
class InterestsNotifier extends StateNotifier<List<Interest>> {
  final GetAllInterests _getAllInterestsUseCase;
  final SaveSelectedInterests _saveSelectedInterestsUseCase;

  InterestsNotifier({
    required GetAllInterests getAllInterestsUseCase,
    required SaveSelectedInterests saveSelectedInterestsUseCase,
  })  : _getAllInterestsUseCase = getAllInterestsUseCase,
        _saveSelectedInterestsUseCase = saveSelectedInterestsUseCase,
        super([]);

  Future<void> loadInterests() async {
    try {
      final interests = await _getAllInterestsUseCase();
      state = interests;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleInterest(String interestId) async {
    final updatedInterests = state.map((interest) {
      if (interest.id == interestId) {
        return interest.copyWith(isSelected: !interest.isSelected);
      }
      return interest;
    }).toList();
    
    state = updatedInterests;
  }

  Future<void> saveInterests() async {
    try {
      final selectedInterests = state.where((interest) => interest.isSelected).toList();
      await _saveSelectedInterestsUseCase(selectedInterests);
    } catch (e) {
      rethrow;
    }
  }
}

// Interests state notifier provider
final interestsNotifierProvider = StateNotifierProvider<InterestsNotifier, List<Interest>>((ref) {
  final getAllInterestsUseCase = ref.watch(getAllInterestsProvider);
  final saveSelectedInterestsUseCase = ref.watch(saveSelectedInterestsProvider);
  
  return InterestsNotifier(
    getAllInterestsUseCase: getAllInterestsUseCase,
    saveSelectedInterestsUseCase: saveSelectedInterestsUseCase,
  );
});
