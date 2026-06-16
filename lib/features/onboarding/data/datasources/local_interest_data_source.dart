import 'package:experience_app/features/onboarding/domain/entities/interest.dart';
import 'interest_data_source.dart';

class LocalInterestDataSource implements InterestDataSource {
  static const List<Interest> _mockInterests = [
    Interest(id: '1', title: 'Fashion', isSelected: false),
    Interest(id: '2', title: 'Electronics', isSelected: false),
    Interest(id: '3', title: 'Sports', isSelected: false),
    Interest(id: '4', title: 'Home', isSelected: false),
    Interest(id: '5', title: 'Books', isSelected: false),
  ];

  // Simulated local storage
  late List<Interest> _savedInterests = [];

  @override
  Future<List<Interest>> getAllInterests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockInterests;
  }

  @override
  Future<void> saveSelectedInterests(List<Interest> interests) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _savedInterests = interests;
  }

  @override
  Future<List<Interest>> getSavedInterests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _savedInterests;
  }
}
