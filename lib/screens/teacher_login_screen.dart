// lib/screens/teacher_login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learningparkeducation/provider/teacher_login_provider.dart';

class TLS extends StatefulWidget {
  @override
  _TeacherLoginScreenState createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TLS> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeacherLoginProvider(),
      child: Consumer<TeacherLoginProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Teacher Login"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefix: Text("+977 "), // Nepal's country code
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await provider.verifyPhoneNumber(_phoneController.text);
                      if (provider.isVerified) {
                        await provider.markAsVerified();
                        // Navigate to the next screen if needed
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NextScreen()));
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Verification failed")),
                        );
                      }
                    },
                    child: Text("Verify Phone"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
