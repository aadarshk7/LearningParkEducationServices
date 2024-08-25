import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningparkeducation/studentscreen/student_homepage.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../choice_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  late String email = '';
  late String password = '';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Future<void> _login(BuildContext context) async {
    //   if (email.isEmpty || password.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text("Please enter email and password"),
    //         backgroundColor: Colors.red,
    //         elevation: 10,
    //         behavior: SnackBarBehavior.floating,
    //         margin: EdgeInsets.all(5),
    //       ),
    //     );
    //     return;
    //   }
    //
    //   try {
    //     UserCredential userCredential = await FirebaseAuth.instance
    //         .signInWithEmailAndPassword(email: email, password: password);
    //
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     await prefs.setBool('isLoggedIn', true);
    //     await prefs.setString('userEmail', email);
    //
    //     // Fetch user type from Firestore
    //     String userType = await _getUserType(email); // Fetch user type
    //
    //     // Debugging output
    //     print('User type: $userType');
    //
    //     // Navigate based on user type
    //     if (userType == 'users') {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => const StudentHomepage()),
    //       );
    //     } else if (userType == 'teachers') {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => const TeacherHomePage()),
    //       );
    //     } else {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (context) => const StudentHomepage()),
    //       );
    //     }
    //   } on FirebaseAuthException catch (e) {
    //     String errorMessage;
    //     if (e.code == 'user-not-found') {
    //       errorMessage = 'No user found for that email.';
    //     } else if (e.code == 'wrong-password') {
    //       errorMessage = 'Wrong password provided for that user.';
    //     } else if (e.code == 'user-disabled') {
    //       errorMessage = 'Your account has been deleted or disabled.';
    //     } else {
    //       errorMessage = 'Email and Password may be wrong.';
    //     }
    //
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(errorMessage),
    //         backgroundColor: Colors.red,
    //         elevation: 10,
    //         behavior: SnackBarBehavior.floating,
    //         margin: const EdgeInsets.all(5),
    //       ),
    //     );
    //   } catch (e) {
    //     print('Exception caught: $e');
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('An error occurred. Please try again.'),
    //         backgroundColor: Colors.red,
    //         elevation: 10,
    //         behavior: SnackBarBehavior.floating,
    //         margin: EdgeInsets.all(5),
    //       ),
    //     );
    //   }
    // }

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
                  "LearningPark Education Login",
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
                              // Attempt to sign in the user
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // Save login state using SharedPreferences
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);
                              await prefs.setString('userEmail', email);

                              // Fetch user type from Firestore
                              String userType =
                                  await _getUserType(email); // Fetch user type

                              // Debugging output
                              print('User type: $userType');

                              // Navigate based on user type
                              if (userType == 'users') {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentHomepage(),
                                  ),
                                );
                              } else if (userType == 'teachers') {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TeacherHomePage(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentHomepage(),
                                  ),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              String errorMessage;
                              if (e.code == 'user-not-found') {
                                errorMessage = 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                errorMessage =
                                    'Wrong password provided for that user.';
                              } else if (e.code == 'user-disabled') {
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
                                  content: Text(
                                      'An error occurred. Please try again.'),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                ),
                              );
                            }
                          },
                          ////
                          /////////
                          /////
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> _getUserType(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDocument = querySnapshot.docs.first;
        print('User document found: ${userDocument.data()}'); // Debug output
        return userDocument['userType'] ??
            'users'; // Adjust field name if necessary
      } else {
        print('No matching user document found for $email'); // Debug output
        return 'users';
      }
    } catch (e) {
      print('Error fetching user type: $e');
      return 'users'; // Default to 'users' in case of an error
    }
  }
}
