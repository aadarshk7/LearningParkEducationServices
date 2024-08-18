import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learningparkeducation/adminpage/adminoptionpage.dart';
import 'package:learningparkeducation/screens/login_screen.dart';
import 'package:learningparkeducation/studentscreen/student_login.dart';
import 'package:learningparkeducation/teacherscreen/teacherhomepage.dart';
import 'package:learningparkeducation/teacherscreen2/subjectpage.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';
import '../studentscreen/studentssubject_list.dart';
import '../phoneotp.dart';
import 'package:learningparkeducation/screens/splash_screen.dart';
import '../screens/teacher_login_screen.dart';

class ChoicePage extends StatefulWidget {
  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> with TickerProviderStateMixin {
  get screenHeight => MediaQuery.of(context).size.height;
  get screenWidth => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 47.0),
            child: Column(
              children: <Widget>[
                Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 47.0),
                  padding: EdgeInsets.fromLTRB(
                      0, screenHeight * 0.16, screenHeight * 0.01, 0),
                  child: Container(
                    height: screenHeight * 0.29,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/singlelogocompressed.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33.0),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      "LearningPark Education MCQ App",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // This color will be overridden by the gradient
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(child: SizedBox(height: screenHeight * 0.09)),
                _buildChoiceButton(
                  context: context,
                  label: "Teacher",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TeacherHomePage(),
                    ));
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildChoiceButton(
                  context: context,
                  label: "Student",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => StudentSubjectList(),
                    ));
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding:
          // EdgeInsets.symmetric(vertical: screenWidth * 0.0),
          // EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          const EdgeInsets.symmetric(horizontal: 47.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 33, 150, 243), // New start color (Blue)
              Color.fromARGB(255, 3, 169, 244), // New end color (Cyan)
            ],
          ),
        ),
        child: Center(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white, // Changed text color to black
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
