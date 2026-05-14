import 'package:experience_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:experience_app/features/onboarding/presentation/views/interests_view.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<OnboardingModel> items = [
    OnboardingModel(
      title: "Create a prototype in just a few minutes",
      subtitle:
          "Enjoy these pre-made components and worry only about creating the best product ever.",
      image: "assets/onboarding.png",
    ),
    OnboardingModel(
      title: "Create a prototype",
      subtitle: "Build apps quickly and easily.",
      image: "assets/onboarding.png",
    ),
    OnboardingModel(
      title: "Launch your app",
      subtitle: "Ship your ideas.",
      image: "assets/onboarding.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        itemCount: items.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final item = items[index];

          return Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFDDE3EC),
                  child: Center(child: Image.asset(item.image, width: 800)),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          items.length,
                          (dotIndex) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentPage == dotIndex
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            if (currentPage < items.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                            if (currentPage == items.length - 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => InterestsView(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            currentPage == items.length - 1
                                ? "Get Started"
                                : "Next",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
