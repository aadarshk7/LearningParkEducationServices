// import 'package:ambulancesewa/login_signup/phoneopt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';

import '../teacherscreen2/teacher_login_screen.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  void signUp() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential userCredential) {
      // Ensure UserCredential is used correctly
      User? user = userCredential.user; // Ensure User is used correctly
      // Your existing code...
    }).catchError((error) {
      // Handle error
    });
  }

  bool _obscureText = true;
  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // GoogleSignIn googleAuth = GoogleSignIn();
  late String email = '';
  late String name;
  late String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/singlelogocompressed.jpg',
                          ),
                          fit: BoxFit.contain)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: 145,
                          top: 333,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                  color: Colors.lightBlue.shade900,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ],
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
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                                  ),
                              child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  }),
                            ),
                            Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                    //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                                    ),
                                child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    })),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
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
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ]),
                        ),
                        child: Center(
                          child: TextButton(
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            onPressed: () async {
                              // Add validation checks here
                              if (email.isEmpty || password.isEmpty) {
                                const snackdemo = SnackBar(
                                  content:
                                      Text("Please enter email and password"),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                                return; // Return from the function if validation fails
                              }
                              // Check if the email is valid
                              RegExp regex = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (!regex.hasMatch(email)) {
                                const snackdemo = SnackBar(
                                  content: Text("Please enter a valid email"),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                                return; // Return from the function if validation fails
                              }
                              // Check if the password is at least 8 characters long
                              if (password.length < 8) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                      "Password must be at least 8 characters long"),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                                return; // Return from the function if validation fails
                              }
                              var querySnapshot = await _firestore
                                  .collection('teachers')
                                  .where('email', isEqualTo: email)
                                  .get();
                              if (querySnapshot.docs.length >= 2) {
                                const snackdemo = SnackBar(
                                  content:
                                      Text("The email address has been used."),
                                  backgroundColor: Colors.red,
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(5),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                                return; // Return from the function if validation fails
                              }

                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((UserCredential userCredential) {
                                User? user = userCredential.user;
                                user?.updateDisplayName(name);
                                _firestore.collection('teachers').add({
                                  'name': name,
                                  'email': email,
                                  'pass': password,
                                }).then((value) {
                                  if (user != null) {
                                    Navigator.pushNamed(
                                        context, '/teacher_login_screen');
                                  }
                                }).catchError((e) {
                                  print(e.toString());
                                });
                              }).catchError((e) {
                                print(e.toString());
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TeacherLoginScreen()),
                          );
                        },
                        child: const Text(
                          "Phone OTP Verification",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
