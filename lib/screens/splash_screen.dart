import 'package:flutter/material.dart';
import 'package:learningparkeducation/choice_screen.dart';
import 'package:learningparkeducation/studentscreen/student_homepage.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userType = prefs.getString('userType') ?? '';

    // Delay for the splash screen display
    await Future.delayed(const Duration(seconds: 3));

    // Navigate based on the login status and user type
    if (isLoggedIn) {
      if (userType == 'users') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StudentHomepage()),
        );
      } else if (userType == 'teachers') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TeacherHomePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChoicePage()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ChoicePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/logo.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
// Compare this snippet from lib/Prov_screen/pov_teacherprovider.dart:
