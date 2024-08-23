import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTeachers extends StatefulWidget {
  const AddTeachers({super.key});

  @override
  State<AddTeachers> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<AddTeachers> {
  bool _obscureText = true;
  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  late String email = '';
  late String name;
  late String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.lightBlue.shade900,
        title: Text(
          "Staff",
          style: GoogleFonts.openSans(
            fontSize: 25,
            color: Colors.lightBlue.shade900,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  "Add new Staff or Teacher",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // This color will be overridden by the gradient
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                context,
                label: "Name",
                icon: Icons.person,
                onChanged: (value) => setState(() => name = value),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                context,
                label: "Email",
                icon: Icons.email,
                onChanged: (value) => setState(() => email = value),
              ),
              const SizedBox(height: 20),
              _buildPasswordInputField(
                context,
                label: "Password",
                icon: Icons.lock,
                obscureText: _obscureText,
                onVisibilityToggle: () =>
                    setState(() => _obscureText = !_obscureText),
                onChanged: (value) => setState(() => password = value),
              ),
              const SizedBox(height: 35),
              Padding(
                // padding: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 55.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(
                          255, 33, 150, 243), // New start color (Blue)
                      Color.fromARGB(255, 3, 169, 244), // New end color (Cyan)
                    ]),
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        _addTeachers();
                      },
                      child: const Text(
                        "Add",
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
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              //     backgroundColor: Colors.lightBlue.shade900,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     elevation: 5,
              //   ),
              //   onPressed: _addUser,
              //   child: const Text(
              //     "Add",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 22,
              //     ),
              //   ),
              // ),
              //
              //
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context,
      {required String label,
      required IconData icon,
      required ValueChanged<String> onChanged}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.lightBlue.shade900),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue.shade900),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue.shade900),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordInputField(BuildContext context,
      {required String label,
      required IconData icon,
      required bool obscureText,
      required VoidCallback onVisibilityToggle,
      required ValueChanged<String> onChanged}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.lightBlue.shade900),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.lightBlue.shade900,
          ),
          onPressed: onVisibilityToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue.shade900),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue.shade900),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  void _addTeachers() async {
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter email and password", Colors.red);
      return;
    }

    RegExp regex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );
    if (!regex.hasMatch(email)) {
      _showSnackBar("Please enter a valid email", Colors.red);
      return;
    }

    if (password.length < 8) {
      _showSnackBar("Password must be at least 8 characters long", Colors.red);
      return;
    }

    var querySnapshot = await _firestore
        .collection('teachers')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _showSnackBar("The email address has been used.", Colors.red);
      return;
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential userCredential) {
      User? user = userCredential.user;
      user?.updateDisplayName(name);
      _firestore.collection('teachers').add({
        'name': name,
        'email': email,
        'pass': password,
      }).then((value) {
        if (user != null) {
          _showSnackBar(
              "New Staff/Teacher has been successfully added", Colors.green);
          Navigator.pushNamed(context, '/settings_page');
        }
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
