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
  bool _isSubmitted = false;

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
            print('Loaded question: ${questionData['question']}');
            print('Correct Option from DB: ${questionData['correctOption']}');

            return {
              'question': questionData['question'],
              'options': List<String>.from(questionData['options']),
              'correctOption': questionData['correctOption'] != null
                  ? questionData['correctOption'].toString()
                  : null,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        print('Questions map is null');
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
        final correctOption = _questions[i]['correctOption'];

        // Extract the numeric part of the correct option
        final correctOptionIndex =
            int.parse(correctOption.replaceAll(RegExp(r'[^0-9]'), '')) - 1;

        print(
            'Question ${i + 1}: Selected Answer: $selectedAnswer, Correct Answer: $correctOptionIndex');

        // Compare the selected answer index with the correct option index
        if (selectedAnswer != null && selectedAnswer == correctOptionIndex) {
          score += 1; // Increment score if the answer is correct
        } else {
          print(
              'Answer mismatch or null: Selected: $selectedAnswer, Correct: $correctOptionIndex');
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
          title: Text('You have submitted the test!'),
          content: Text('Your score is $score/${_questions.length}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _restartTest(); // Restart the test
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _restartTest() {
    setState(() {
      _selectedAnswers.clear();
      _isLoading = true;
    });
    _loadQuestions(); // Reload the questions
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
          : ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ..._questions.asMap().entries.map((entry) {
                  int index = entry.key;
                  var question = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                }).toList(),
                SizedBox(height: 20),
                if (_selectedAnswers.length == _questions.length)
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitAnswers,
                      child: Text('Submit'),
                    ),
                  ),
              ],
            ),
      floatingActionButton: null, // Remove the floating action button
    );
  }
}
