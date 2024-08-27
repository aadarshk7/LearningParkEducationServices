import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;

  Future<void> login(String email, String password) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('teachers')
          .where('email', isEqualTo: email)
          .where('pass', isEqualTo: password) // Consider hashing the password
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _isLoggedIn = true;
        _email = email;
        await _saveLoginState();
        notifyListeners();
      } else {
        print('Invalid email or password');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _email = null;
    await _clearLoginState();
    notifyListeners();
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('teacherEmail', _email ?? '');
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('teacherEmail');
  }

  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('teacherEmail');
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}
