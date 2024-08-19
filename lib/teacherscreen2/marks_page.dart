import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class MarksPage extends StatefulWidget {
  @override
  _MarksPageState createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  final DatabaseReference _marksRef =
      FirebaseDatabase.instance.ref().child('studenttestmarks');
  Map<String, Map<String, dynamic>> _marksData = {};

  @override
  void initState() {
    super.initState();
    _fetchMarks();
  }

  Future<void> _fetchMarks() async {
    try {
      final snapshot = await _marksRef.get();
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final convertedData = <String, Map<String, dynamic>>{};
        data.forEach((key, value) {
          if (value is Map) {
            convertedData[key.toString()] = Map<String, dynamic>.from(value);
          }
        });

        setState(() {
          _marksData = convertedData;
        });
      } else {
        setState(() {
          _marksData = {};
        });
      }
    } catch (e) {
      print('Error fetching marks: $e');
      setState(() {
        _marksData = {};
      });
    }
  }

  Future<String?> _fetchStudentName(String email) async {
    email = email.replaceAll(',', '.');
    try {
      print("Fetching student name for email: $email");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final studentName = doc.data()['name'] as String?;
        print("Student name found: $studentName");
        return studentName;
      } else {
        print("No document found for this email.");
      }
    } catch (e) {
      print("Error fetching student name: $e");
    }
    return null;
  }

  Future<void> _deleteMark(String email) async {
    try {
      await _marksRef.child(email).remove();
      setState(() {
        _marksData.remove(email);
      });
    } catch (e) {
      print('Error deleting mark: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marks',
          style: GoogleFonts.openSans(),
        ),
      ),
      body: _marksData.isEmpty
          ? Center(child: Text('No marks available'))
          : ListView.builder(
              itemCount: _marksData.length,
              itemBuilder: (context, index) {
                final email = _marksData.keys.elementAt(index);
                final markData = _marksData[email]!;

                return FutureBuilder<String?>(
                  future: _fetchStudentName(email),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final studentName = snapshot.data ?? 'No name found';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: Colors.black26,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            studentName,
                            style: GoogleFonts.openSans(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '$email\nSubject: ${markData['subject']} - Score: ${markData['score']}',
                            style: GoogleFonts.openSans(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteMark(email),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
