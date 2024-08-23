import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentTestPage extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  const StudentTestPage(
      {super.key, required this.subjectName, required this.questionsRef});

  @override
  _StudentTestPageState createState() => _StudentTestPageState();
}

class _StudentTestPageState extends State<StudentTestPage> {
  List<Question> _questions = [];
  final Map<int, int> _selectedAnswers = {};
  bool _isLoading = true;
  final bool _isSubmitted = false;
  bool _noQuestions = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      widget.questionsRef.child(widget.subjectName).onValue.listen((event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> questionsMap =
              event.snapshot.value as Map<dynamic, dynamic>;
          List<Question> questionsList = questionsMap.entries.map((entry) {
            final questionMap = Map<String, dynamic>.from(entry.value);
            return Question.fromMap(questionMap, entry.key);
          }).toList();

          setState(() {
            _questions = questionsList;
            _isLoading = false;
            _noQuestions = false;
          });
        } else {
          setState(() {
            _questions = [];
            _isLoading = false;
            _noQuestions = true;
          });
        }
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        _isLoading = false;
        _noQuestions = true;
      });
    }
  }

  Future<void> _submitAnswers() async {
    try {
      int score = 0;
      List<String> results = [];

      for (int i = 0; i < _questions.length; i++) {
        final selectedAnswer = _selectedAnswers[i];
        final correctOption = _questions[i].correctOption;

        final correctOptionIndex =
            int.parse(correctOption!.replaceAll(RegExp(r'[^0-9]'), '')) - 1;

        String result = 'Question ${i + 1}: ';
        if (selectedAnswer != null) {
          if (selectedAnswer == correctOptionIndex) {
            score += 1;
            result +=
                'Selected Answer: ${selectedAnswer + 1}, Correct Answer: ${correctOptionIndex + 1} (Correct)';
          } else {
            result +=
                'Selected Answer: ${selectedAnswer + 1}, Correct Answer: ${correctOptionIndex + 1} (Incorrect)';
          }
        } else {
          result +=
              'No answer selected, Correct Answer: ${correctOptionIndex + 1} (Unanswered)';
        }

        results.add(result);
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final email = user.email?.replaceAll('.', ',');
        final studentRef = FirebaseDatabase.instance
            .ref()
            .child('studenttestmarks')
            .child(email!);
        await studentRef.set({
          'subject': widget.subjectName,
          'score': score,
          'timestamp': DateTime.now().toIso8601String(),
        });

        _showScoreDialog(score, results);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not logged in. Unable to save score.'),
          ),
        );
      }
    } catch (e) {
      print('Error during submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while submitting the test.'),
        ),
      );
    }
  }

  void _showScoreDialog(int score, List<String> results) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Test Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your score is $score/${_questions.length}.'),
              const SizedBox(height: 10),
              ...results.map((result) => Text(result)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _restartTest(); // Restart the test
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text('Error'),
          content:
              const Text('Please attempt all questions before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
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
      _noQuestions = false;
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
          ? const Center(child: CircularProgressIndicator())
          : _noQuestions
              ? const Center(
                  child: Text('No questions available for this subject.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    var question = _questions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${index + 1}: ${question.question}',
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(question.options!.length, (i) {
                              return RadioListTile<int>(
                                value: i,
                                groupValue: _selectedAnswers[index],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAnswers[index] = value!;
                                  });
                                },
                                title: Text(
                                  question.options![i],
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: Colors.blueGrey[700],
                                  ),
                                ),
                                tileColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: EdgeInsets.all(12.0),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
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
            const Text(
              'Submit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String id;
  final String? question;
  final List<String>? options;
  final String? correctOption;

  Question({
    required this.id,
    this.question,
    this.options,
    this.correctOption,
  });

  factory Question.fromMap(Map<String, dynamic> map, String id) {
    return Question(
      id: id,
      question: map['question'] as String?,
      options:
          map['options'] != null ? List<String>.from(map['options']) : null,
      correctOption: map['correctOption'] as String?,
    );
  }
}
