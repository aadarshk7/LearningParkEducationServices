import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
    try {
      final snapshot = await widget.questionsRef.get();
      final questionsMap = snapshot.value as Map<dynamic, dynamic>?;

      if (questionsMap != null) {
        setState(() {
          _questions = questionsMap.entries.map((entry) {
            final questionData = entry.value as Map<dynamic, dynamic>;
            return {
              'question': questionData['question'],
              'options': List<String>.from(questionData['options']),
              'correctOption': questionData['correctOption'].toString(),
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  Future<void> _submitAnswers() async {
    try {
      int score = 0;
      for (int i = 0; i < _questions.length; i++) {
        final selectedAnswer = _selectedAnswers[i];
        final correctOption = int.tryParse(_questions[i]['correctOption'] ?? '');

        print('Question ${i + 1}: Selected Answer: $selectedAnswer, Correct Answer: $correctOption');

        // Ensure both are valid integers and compare them
        if (selectedAnswer != null && correctOption != null && selectedAnswer == correctOption) {
          score += 1; // Increment score if the answer is correct
        } else {
          print('Answer mismatch or null: Selected: $selectedAnswer, Correct: $correctOption');
        }
      }

      _showScoreDialog(score);
    } catch (e) {
      print('Error during submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while submitting the test.'),
        ),
      );
    }
  }

  void _showScoreDialog(int score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have scored $score/${_questions.length}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                                  setState(() {
                                    _selectedAnswers[index] = value!;
                                  });
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedAnswers.length == _questions.length) {
                        _submitAnswers(); // Submit the answers
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please answer all the questions before submitting.'),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
    );
  }
}
