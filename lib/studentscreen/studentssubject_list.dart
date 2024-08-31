import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../teacherscreen2/subjectpage.dart';

class StudentSubjectList extends StatelessWidget {
  final List<String> subjects = [
    'Accounting',
    'Finance',
    'Economics',
    'Management',
  ];

  StudentSubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject List'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectPage(
                    subjectName: subjects[index],
                    questionsRef: FirebaseDatabase.instance
                        .ref()
                        .child('questions')
                        .child(subjects[index]),
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
