import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learningparkeducation/teacherscreen/userpage.dart';
import '../studentscreen/studentssubject_list.dart';
import 'subject_page.dart' as teacher;

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'userpage.dart';
import 'subject_page.dart' as teacher;

class TeacherHomePage extends StatelessWidget {
  final DatabaseReference _subjectsRef =
      FirebaseDatabase.instance.ref().child('subjects');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard', style: TextStyle(fontSize: 24)),
        actions: [Icon(Icons.person), Icon(Icons.settings)],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _subjectsRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    !snapshot.data!.snapshot.exists) {
                  return Center(child: Text('No subjects available.'));
                } else {
                  Map<dynamic, dynamic> subjects =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List subjectNames = subjects.keys.toList();

                  return ListView.builder(
                    itemCount: subjectNames.length,
                    itemBuilder: (context, index) {
                      String subjectName = subjectNames[index];
                      return ListTile(
                        title: Text(
                          subjectName,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  teacher.SubjectPage(subjectName: subjectName),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addQuestion(context);
        },
      ),
    );
  }

  void _addQuestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _questionController = TextEditingController();
        TextEditingController _subjectController = TextEditingController();

        return AlertDialog(
          title: Text('Add Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String subject = _subjectController.text.trim();
                String question = _questionController.text.trim();

                if (subject.isNotEmpty && question.isNotEmpty) {
                  _subjectsRef
                      .child(subject)
                      .push()
                      .set({'question': question});
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
