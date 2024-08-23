import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Studenttestscreen extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  const Studenttestscreen({super.key, required this.subjectName, required this.questionsRef});

  @override
  _StudentTestPageState createState() => _StudentTestPageState();
}

class _StudentTestPageState extends State<Studenttestscreen> {
  List<Map<String, dynamic>> _questions = [];
  List<int?> _selectedAnswers = []; // Changed from Map<int, int> to List<int?>

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
              'correctOption': questionData['correctOption']?.toString(),
            };
          }).toList();
          _selectedAnswers = List<int?>.filled(
              _questions.length, null); // Initialize with nulls
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
            int.parse(correctOption?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') -
                1;

        if (selectedAnswer != null && selectedAnswer == correctOptionIndex) {
          score += 1; // Increment score if the answer is correct
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final studentEmail = prefs.getString('email') ?? 'unknown_email';
      final subjectName = widget.subjectName;
      final timestamp = DateTime.now().toIso8601String();

      // Convert email to Firestore-compatible format
      final formattedEmail =
          studentEmail.replaceAll('.', '_').replaceAll('@', '_');

      final DatabaseReference studentMarksRef = FirebaseDatabase.instance
          .ref('studenttestmarks/$formattedEmail/$subjectName');

      await studentMarksRef.set({
        'score': score,
        'subject': subjectName,
        'timestamp': timestamp,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            questions: _questions,
            selectedAnswers: _selectedAnswers, // Pass as List<int?>
          ),
        ),
      );
    } catch (e) {
      print('Error during submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while submitting the test.'),
        ),
      );
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text('Error'),
          content: const Text('Please attempt all questions before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                if (_selectedAnswers.length == _questions.length) {
                  _submitAnswers();
                } else {
                  _showErrorDialog();
                }
              },
              iconSize: 40,
              color: Colors.green,
              tooltip: 'Submit Answers',
            ),
            const Text('Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final List<Map<String, dynamic>> questions;
  final List<int?> selectedAnswers;

  const ResultPage({super.key, 
    required this.score,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $score',
              style: const TextStyle(fontSize: 24),
            ),
            // Additional UI elements to show questions and answers
          ],
        ),
      ),
    );
  }
}
