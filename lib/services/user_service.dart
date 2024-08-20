import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteUser(String uid) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    // Ensure the user being deleted is the current user
    if (user.uid != uid) {
      throw Exception("User ID mismatch.");
    }

    // Delete user from Firebase Authentication
    await user.delete();

    // Delete user document from Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();

    print('User successfully deleted.');
  } catch (e) {
    print('Error deleting user: $e');
  }
}
