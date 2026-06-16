import 'package:experience_app/features/onboarding/domain/entities/interest.dart';
import 'package:experience_app/features/onboarding/domain/repositories/interest_repository.dart';

class GetAllInterests {
  final InterestRepository repository;

  GetAllInterests(this.repository);

  Future<List<Interest>> call() async {
    return await repository.getAllInterests();
  }
}
