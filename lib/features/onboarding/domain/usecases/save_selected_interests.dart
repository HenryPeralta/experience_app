import 'package:experience_app/features/onboarding/domain/entities/interest.dart';
import 'package:experience_app/features/onboarding/domain/repositories/interest_repository.dart';

class SaveSelectedInterests {
  final InterestRepository repository;

  SaveSelectedInterests(this.repository);

  Future<void> call(List<Interest> interests) async {
    return await repository.saveSelectedInterests(interests);
  }
}
