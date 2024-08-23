import 'package:flutter/material.dart';
import 'package:learningparkeducation/studentscreen/questionpage.dart';

class SubjectListPage extends StatelessWidget {
  final List<String> subjects = ['Account', 'Economics', 'Math'];

  SubjectListPage({super.key}); // Example subjects

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subject'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return ListTile(
            title: Text(subject),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionsPage(subjectName: subject),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
