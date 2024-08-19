import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String studentName;

  ProfilePage({required this.studentName});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? age;
  String? imageUrl;
  File? _imageFile;
  final TextEditingController _ageController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('profile_image');
      _ageController.text = prefs.getString('age') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload image to Firebase Storage
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      if (_imageFile == null) return;

      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Check if the Firestore document exists
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          throw Exception('User document does not exist');
        }

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        final uploadTask = storageRef.putFile(_imageFile!);

        uploadTask.snapshotEvents.listen((event) {
          print('Task state: ${event.state}');
          print(
              'Progress: ${(event.bytesTransferred / event.totalBytes) * 100} %');
        }).onError((error) {
          print('Error: $error');
        });

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });

        // Save the image URL to Firestore
        await userDoc.update({'profile_image': downloadUrl});

        // Save image URL to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', downloadUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  Future<void> _saveAge() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        if (!(await userDoc.get()).exists) {
          throw Exception('User document does not exist');
        }

        await userDoc.update({'age': _ageController.text});

        // Save age to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('age', _ageController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Age updated successfully!')),
        );
      }
    } catch (e) {
      print('Error updating age: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update age: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Profile Page',
      //     style: GoogleFonts.openSans(),
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null || imageUrl != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : NetworkImage(imageUrl!) as ImageProvider,
                  )
                : CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            Text(
              widget.studentName,
              style: GoogleFonts.openSans(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Age: ${_ageController.text}',
              style: GoogleFonts.openSans(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Enter your age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAge,
              child: Text('Save Age'),
            ),
          ],
        ),
      ),
    );
  }
}
