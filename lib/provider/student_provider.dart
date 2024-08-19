import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProvider with ChangeNotifier {
  String _studentName = "Loading...";
  String get studentName => _studentName;

  Future<void> fetchStudentName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final email = user.email;
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          _studentName = doc.data()['name'] ?? 'No name found';
        } else {
          _studentName = 'No name found';
        }
        notifyListeners();
      } catch (e) {
        print("Error fetching student name: $e");
        _studentName = 'Error loading name';
        notifyListeners();
      }
    } else {
      _studentName = 'User not logged in';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    // Clear login state
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
