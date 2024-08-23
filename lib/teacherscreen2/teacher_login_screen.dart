import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<TeacherLoginScreen> {
  bool _obscureText = true;
  late String email = '';
  late String password = '';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, screenHeight * 0.11, screenHeight * 0.01, 0),
              child: Container(
                height: screenHeight * 0.22,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/singlelogocompressed.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  "LearningPark Education Teacher Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(padding: const EdgeInsets.all(8.0)),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 77,
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: _obscureText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 47),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 33, 150, 243),
                          Color.fromARGB(255, 3, 169, 244),
                        ]),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please enter email and password"),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                ),
                              );
                              return;
                            }

                            try {
                              // Verify if the email belongs to a teacher
                              final QuerySnapshot result =
                                  await FirebaseFirestore.instance
                                      .collection('teachers')
                                      .where('email', isEqualTo: email)
                                      .get();

                              if (result.docs.isEmpty) {
                                throw FirebaseAuthException(
                                  code: 'not-teacher',
                                  message:
                                      'This email is not authorized as a teacher.',
                                );
                              }

                              // Attempt to sign in the user
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // If the sign-in is successful, navigate to the homepage
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const TeacherHomePage(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              String errorMessage;
                              if (e.code == 'not-teacher') {
                                errorMessage =
                                    'This email is not authorized as a teacher.';
                              } else if (e.code == 'wrong-password') {
                                errorMessage =
                                    'Wrong password provided for that teacher.';
                              } else if (e.code == 'teacher-disabled') {
                                errorMessage =
                                    'Your account has been deleted or disabled.';
                              } else {
                                errorMessage =
                                    'Email and Password may be wrong.';
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(5),
                                ),
                              );
                            } catch (e) {
                              print('Exception caught: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Email and Password may be wrong.'),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 23),
                ],
              ),
            )
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 47.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 33, 150, 243),
              Color.fromARGB(255, 3, 169, 244),
            ],
          ),
        ),
        child: Center(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
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
