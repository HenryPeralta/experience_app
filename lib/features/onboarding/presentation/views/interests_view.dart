import 'package:experience_app/features/onboarding/data/models/interests_model.dart';
import 'package:flutter/material.dart';

class InterestsView extends StatefulWidget {
  const InterestsView({super.key});

  @override
  State<InterestsView> createState() => _InterestsViewState();
}

class _InterestsViewState extends State<InterestsView> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<InterestModel> interests = [
    InterestModel(title: 'User Interface'),
    InterestModel(title: 'User Experience'),
    InterestModel(title: 'User Research'),
    InterestModel(title: 'UX Writing'),
    InterestModel(title: 'User Testing'),
    InterestModel(title: 'Service Design'),
    InterestModel(title: 'Strategy'),
    InterestModel(title: 'Design Systems'),
  ];

  void toggleSelection(int index) {
    setState(() {
      interests[index].isSelected = !interests[index].isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),

      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Personalise your\nexperience',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Choose your interests.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 32),
                  Expanded(
                    child: ListView.separated(
                      itemCount: interests.length,
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = interests[index];
                        return GestureDetector(
                          onTap: () => toggleSelection(index),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 22,
                            ),
                            decoration: BoxDecoration(
                              color: item.isSelected
                                  ? Color(0xFFE8EEF9)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: item.isSelected
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (item.isSelected)
                                  Icon(Icons.check, color: Colors.blue),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(child: Text('Page in progress', style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }
}
