import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentTestPage extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  StudentTestPage({required this.subjectName, required this.questionsRef});

  @override
  _StudentTestPageState createState() => _StudentTestPageState();
}

class _StudentTestPageState extends State<StudentTestPage> {
  List<Map<String, dynamic>> _questions = [];
  Map<int, int> _selectedAnswers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final snapshot = await widget.questionsRef.get();
    final questionsMap = snapshot.value as Map<dynamic, dynamic>?;

    if (questionsMap != null) {
      setState(() {
        _questions = questionsMap.entries.map((entry) {
          final questionData = entry.value as Map<dynamic, dynamic>;
          return {
            'question': questionData['question'],
            'options': List<String>.from(questionData['options']),
            'correctOption': questionData['correctOption'],
          };
        }).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAnswers() async {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final correctOption = int.parse(_questions[i]['correctOption']);
      if (_selectedAnswers[i] == correctOption) {
        score += 1; // Each question is worth 1 point
      }
    }

    _showScoreDialog(score);
  }

  void _showScoreDialog(int score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('You have submitted the test!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your score is $score/${_questions.length}.'),
              SizedBox(height: 16.0),
              Text('Correct Answers:'),
              ..._questions.asMap().entries.map((entry) {
                int index = entry.key;
                var question = entry.value;
                return ListTile(
                  title: Text('Q${index + 1}. ${question['question']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Answer: ${_selectedAnswers[index] != null ? question['options'][_selectedAnswers[index]!] : "Not Answered"}'),
                      Text('Correct Answer: ${question['options'][int.parse(question['correctOption'])]}'),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subjectName,
          style: GoogleFonts.openSans(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}. ${question['question']}',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...List.generate(question['options'].length, (i) {
                        return RadioListTile<int>(
                          value: i,
                          groupValue: _selectedAnswers[index],
                          onChanged: (value) {
                            if (_selectedAnswers[index] == null) {
                              setState(() {
                                _selectedAnswers[index] = value!;
                              });
                            }
                          },
                          title: Text(
                            question['options'][i],
                            style: GoogleFonts.openSans(fontSize: 16),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: _selectedAnswers.length < _questions.length
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (_selectedAnswers.length == _questions.length) {
                  _submitAnswers();
                }
              },
              label: Text('Submit'),
              icon: Icon(Icons.check),
            ),
    );
  }
}
