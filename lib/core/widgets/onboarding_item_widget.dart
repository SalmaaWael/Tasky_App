import 'package:flutter/material.dart';

import '../colors_manager/colors_manager.dart';

class OnboardingItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingItemWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 40),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: ColorsManager.textLargeColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: ColorsManager.textSmallColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}