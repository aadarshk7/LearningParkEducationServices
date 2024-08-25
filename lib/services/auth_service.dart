import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../studentscreen/student_homepage.dart';

Future<void> signInAndVerify(
    String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Check if the user exists in Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .get();

    if (!userDoc.exists) {
      // User does not exist in Firestore, sign out the user
      await FirebaseAuth.instance.signOut();
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User account does not exist in Firestore.',
      );
    }

    // Proceed with navigation if user exists
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const StudentHomepage()));
  } on FirebaseAuthException catch (e) {
    // Handle authentication exceptions
    print('Firebase Auth Error: ${e.message}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')));
  } catch (e) {
    // Handle other exceptions
    print('Error: $e');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('An unexpected error occurred')));
  }
}
