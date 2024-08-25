import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningparkeducation/Prov_screen/pov_teacherprovider.dart';
import 'package:learningparkeducation/screens/splash_screen.dart';
import 'package:learningparkeducation/studentscreen/student_homepage.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatbot/chat_provider.dart';
import 'Prov_screen/prov_authprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCqDgbG5Nau5-8QhmxshXGcZ2R8HQZ-C00",
      authDomain: "learningparkeducation.firebaseapp.com",
      projectId: "learningparkeducation",
      storageBucket: "learningparkeducation.appspot.com",
      messagingSenderId: "939288879280",
      appId: "1:45063901374:web:45063901374",
      measurementId: "G-FREWCBF7Y1",
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String userType =
      prefs.getString('userType') ?? 'users'; // 'student' or 'teacher'

  runApp(MyApp(isLoggedIn: isLoggedIn, userType: userType));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userType;

  MyApp({required this.isLoggedIn, required this.userType});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => TeacherAuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn
            ? (userType == 'teachers' ? TeacherHomePage() : StudentHomepage())
            : SplashScreen(),
      ),
    );
  }
}
