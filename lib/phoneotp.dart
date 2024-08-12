import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningparkeducation/choice_screen.dart';
import 'package:learningparkeducation/screens/splash_screen.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreen();
}

class _TeacherLoginScreen extends State<TeacherLoginScreen> {
  bool showOtpField = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String phoneNo, verificationId;
  late String smsCode = '';
  String errorMessage = '';
  bool isCodeSent = false;

  Future<void> verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+977$phoneNo',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        try {
          UserCredential result =
              await _auth.signInWithCredential(authCredential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NextScreen(),
            ),
          );
        } catch (e) {
          print(e);
        }
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          errorMessage = authException.message!;
        });
        print(errorMessage);
      },
      codeSent: (String verId, [int? forceCodeResend]) {
        this.verificationId = verId;
        setState(() {
          this.isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        this.verificationId = verId;
      },
    );
  }

  void signInWithOTP(String smsCode, String verId) async {
    try {
      PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
      UserCredential result =
          await _auth.signInWithCredential(phoneAuthCredential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NextScreen(),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The provided verification code is invalid.'),
            backgroundColor: Colors.red,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(5),
          ),
        );
      } else {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              children: <Widget>[
                // Padding(
                //   // padding: const EdgeInsets.symmetric(horizontal: 47.0),
                //   padding: EdgeInsets.fromLTRB(
                //       0, screenHeight * 0.16, screenHeight * 0.01, 0),
                //   child: Container(
                //     height: screenHeight * 0.29,
                //     decoration: const BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage(
                //             'assets/images/singlelogocompressed.jpg'),
                //         fit: BoxFit.contain,
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, screenHeight * 0.16, screenHeight * 0.01, 0),
                  child: Container(
                    height: screenHeight * 0.29,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 4.0, // Adjust the width as needed
                      ),
                    ),
                    child: ClipOval(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/singlelogocompressed.jpg'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.00),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      "Phone Verification with OTP",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "XXXXXXXXXX",
                            labelText: "Phone Number",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/nepal_flag.png',
                                height: 20,
                                width: 20,
                              ),
                            ),
                            prefixText: "+977 ",
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            this.phoneNo = value;
                          },
                        ),
                      ),
                      Visibility(
                        visible: showOtpField,
                        child: Container(
                          // height: screenHeight * 0.17,
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: "Enter OTP",
                              prefixIcon: Icon(Icons.chat),
                            ),
                            onChanged: (value) {
                              this.smsCode = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        child: Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.8,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 33, 150, 243),
                              Color.fromARGB(255, 3, 169, 244),
                            ]),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    showOtpField = true;
                                  });
                                  isCodeSent
                                      ? signInWithOTP(smsCode, verificationId)
                                      : verifyPhone();
                                }
                              },
                              child: Text(
                                isCodeSent ? 'Login' : 'Verify',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 47.0),
      child: Container(
        height: 33,
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
