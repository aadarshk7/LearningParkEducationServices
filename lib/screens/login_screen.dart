// import 'package:ambulancesewa/login_signup/phoneopt.dart';
// import 'package:ambulancesewa/login_signup/signup_page.dart';
// import 'package:ambulancesewa/userpage/user_page.dart';
// import 'package:ambulancesewa/screens/choicepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:learningparkeducation/screens/signup_screen.dart';
import 'package:learningparkeducation/teacherscreen2/teacherhomepage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  // GoogleSignIn googleAuth = GoogleSignIn();
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
                  // padding: const EdgeInsets.symmetric(horizontal: 47.0),
                  padding: EdgeInsets.fromLTRB(
                      0, screenHeight * 0.16, screenHeight * 0.01, 0),
                  child: Container(
                    height: screenHeight * 0.25,
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
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      "LearningPark Education Student Login",
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
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
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
                            padding: EdgeInsets.all(8.0),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
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
                              },
                            ),
                          ),
                          Container(
                            height: 77,
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
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
                          ),

                          //Forgot Password option

                          // SizedBox(height: 12),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       // Handle forgot password
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(builder: (context) => ForgotPassword()),
                          //       );
                          //     },
                          //     child: const Text(
                          //       "Forgot Password?",
                          //       style: TextStyle(
                          //         color: Colors.blue,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 47),
                   child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 33, 150, 243), // New start color (Blue)
                       Color.fromARGB(255, 3, 169, 244), // New end color (Cyan)
                        ]),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            // Add validation checks here
                            if (email == null ||
                                email.isEmpty ||
                                password == null ||
                                password.isEmpty) {
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

                            String errorMessage = '';
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              // If the sign-in is successful, navigate to the homepage.
                              // Navigator.pushNamed(context, '/splash_screen');

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TeacherHomePage(),
                              ));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                              } else if (e.code == 'wrong-password') {}

                              const snackdemo = SnackBar(
                                content:
                                    Text("Email and Password may be wrong"),
                                // Display the error message
                                backgroundColor: Colors.red,
                                elevation: 10,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(5),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackdemo);
                            } catch (e) {
                              print('Exception caught: $e');
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    //Phone Page
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       //MaterialPageRoute(builder: (context) => PhonePage()),
                    //       MaterialPageRoute(
                    //           builder: (context) => TeacherHomePage()),

                    //       //this
                    //     );
                    //   },
                    //   // child: const Text(
                    //   //       "Forgot Password?",
                    //   //       style: TextStyle(
                    //   //         color: Colors.blue,
                    //   //         fontWeight: FontWeight.bold,
                    //   //       ),
                    //   //     ),
                    //   child: const Text(
                    //     "Phone OTP Verification",
                    //     style: TextStyle(
                    //         color: Colors.blue,
                    //         fontWeight: FontWeight.bold,
                    //         // color: Color.fromRGBO(143, 148, 251, 1),
                    //         fontSize: 18),
                    //   ),
                    // ),
                
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          // admin page shouldn't be there
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignUpPage()), // Replace with your SignupPage
                        );
                      },
                      child: const Text(
                        "Create an Account",
                        style: TextStyle(
                            //color: Color.fromRGBO(143, 148, 251, 1),
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
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