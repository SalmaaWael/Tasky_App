import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasky_app/auth/login_Screen.dart';
import 'package:tasky_app/screens/home/home_screen.dart';
import 'package:tasky_app/screens/onboarding/onboarding_screen.dart';
import 'auth/register_screen.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TaskyApp());
}

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: OnboardingScreen.routeName,
      routes: {
        LoginScreen.routeName: (context)=> LoginScreen(),
        RegisterScreen.routeName: (context)=> RegisterScreen(),
        HomeScreen.routeName: (context)=> HomeScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),

      },
    );
  }
}





///native splash
///icon launcher
///app name
///assets folder
///folder core
///colors - font - images
///common - widgets - utils
