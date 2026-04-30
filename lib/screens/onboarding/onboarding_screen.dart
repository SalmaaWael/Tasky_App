import 'package:flutter/material.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';
import 'package:tasky_app/auth/login_Screen.dart';

import '../../core/widgets/onboarding_item_widget.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = "OnboardingScreen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": AssetsManager.onboard1,
      "title": "Manage your tasks",
      "subtitle": "You can easily manage all of your daily\ntasks in Tasky for free",
    },
    {
      "image": AssetsManager.onboard2,
      "title": "Create daily routine",
      "subtitle": "In Tasky you can create your personalized\nroutine to stay productive",
    },
    {
      "image": AssetsManager.onboard3,
      "title": "Organize your tasks",
      "subtitle": "You can organize your daily tasks by\nadding your tasks into separate categories",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return OnboardingItemWidget(
                      image: onboardingData[index]["image"]!,
                      title: onboardingData[index]["title"]!,
                      subtitle: onboardingData[index]["subtitle"]!,
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      onboardingData.length,
                          (index) => buildDot(index, context),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (currentIndex == onboardingData.length - 1) {
                        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      currentIndex == onboardingData.length - 1 ? "GET STARTED" : "NEXT",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 6,
      width: currentIndex == index ? 24 : 16,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? ColorsManager.primaryColor : Colors.grey.shade300,
      ),
    );
  }
}


