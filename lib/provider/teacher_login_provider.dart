// lib/providers/teacher_login_provider.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/teacher_login_screen.dart';

class TeacherLoginProvider with ChangeNotifier {
  bool _isVerified = false;

  bool get isVerified => _isVerified;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Completer<void> completer = Completer<void>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _isVerified = true;
        notifyListeners();
        completer.complete();
      },
      verificationFailed: (FirebaseAuthException e) {
        _isVerified = false;
        notifyListeners();
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );

    return completer.future;
  }

  Future<void> checkIfVerified() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isVerified = prefs.getBool('isVerified') ?? false;
    notifyListeners();
  }

  Future<void> markAsVerified() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVerified', true);
  }
}
