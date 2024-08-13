import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatefulWidget {
  final String subjectName;

  UserPage({required this.subjectName});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _currentQuestionIndex = 0;
  List<String> _userAnswers = [];
  int _marks = 0;

  void _submitExam() {
    FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.subjectName)
        .collection('questions')
        .get()
        .then((snapshot) {
      int correctAnswers = 0;
      for (int i = 0; i < snapshot.docs.length; i++) {
        if (_userAnswers[i] == snapshot.docs[i]['correctOption']) {
          correctAnswers++;
        }
      }
      setState(() {
        _marks = correctAnswers;
      });
      FirebaseFirestore.instance.collection('users').doc('UserID').update({
        'marks': _marks,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Exam', style: TextStyle(fontSize: 24)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('subjects')
            .doc(widget.subjectName)
            .collection('questions')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var questions = snapshot.data!.docs;

          if (_currentQuestionIndex < questions.length) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Q${_currentQuestionIndex + 1}: ${questions[_currentQuestionIndex]['question']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ...List.generate(4, (index) {
                  return RadioListTile<String>(
                    title: Text(
                        questions[_currentQuestionIndex]['options'][index]),
                    value: 'Option ${index + 1}',
                    groupValue: _userAnswers.length > _currentQuestionIndex
                        ? _userAnswers[_currentQuestionIndex]
                        : null,
                    onChanged: (value) {
                      setState(() {
                        if (_userAnswers.length > _currentQuestionIndex) {
                          _userAnswers[_currentQuestionIndex] = value!;
                        } else {
                          _userAnswers.add(value!);
                        }
                      });
                    },
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex--;
                          });
                        },
                        child: Text('Previous'),
                      ),
                    if (_currentQuestionIndex < questions.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex++;
                          });
                        },
                        child: Text('Next'),
                      ),
                    if (_currentQuestionIndex == questions.length - 1)
                      ElevatedButton(
                        onPressed: _submitExam,
                        child: Text('Submit'),
                      ),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: Text('All questions answered!'));
          }
        },
      ),
    );
  }
}
