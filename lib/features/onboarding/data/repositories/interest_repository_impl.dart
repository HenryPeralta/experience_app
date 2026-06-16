import 'package:experience_app/features/onboarding/domain/entities/interest.dart';
import 'package:experience_app/features/onboarding/domain/repositories/interest_repository.dart';
import 'package:experience_app/features/onboarding/data/datasources/interest_data_source.dart';

class InterestRepositoryImpl implements InterestRepository {
  final InterestDataSource dataSource;

  InterestRepositoryImpl({required this.dataSource});

  @override
  Future<List<Interest>> getAllInterests() async {
    try {
      return await dataSource.getAllInterests();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveSelectedInterests(List<Interest> interests) async {
    try {
      return await dataSource.saveSelectedInterests(interests);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Interest>> getSavedInterests() async {
    try {
      return await dataSource.getSavedInterests();
    } catch (e) {
      rethrow;
    }
  }
}
