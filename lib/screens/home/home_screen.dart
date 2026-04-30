import 'package:flutter/material.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          AssetsManager.logoo,
          height: 30,
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
            },
            icon: Image.asset(
              AssetsManager.logout,
              color: const Color(0xffFF3951),
              width: 24, 
              height: 24,
            ),
            label: const Text(
              "Log out",
              style: TextStyle(
                  color: Color(0xffFF3951),
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetsManager.homeImage,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),

            const Text(
              "What do you want to do today?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ColorsManager.textLargeColor,
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              "Tap + to add your tasks",
              style: TextStyle(
                fontSize: 16,
                color: ColorsManager.textSmallColor,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        backgroundColor: ColorsManager.textLargeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.add,
          color: ColorsManager.primaryColor,
          size: 32,
        ),
      ),
    );
  }
}