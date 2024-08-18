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
  Map<int, int?> _selectedAnswers = {};
  bool _isLoading = true;
  bool _isSubmitted = false;
  int _attemptsLeft = 20; // Maximum 20 attempts to solve questions

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _checkIfSubmitted();
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
            'correctOption': questionData['correctOption'] != null
                ? int.tryParse(questionData['correctOption'].toString())
                : null, // Handle possible null values
          };
        }).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkIfSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ensure attempts left is initialized to 20 if not set
      _attemptsLeft = prefs.getInt('${widget.subjectName}_attemptsLeft') ?? 20;
      _isSubmitted = prefs.getBool('${widget.subjectName}_submitted') ?? false;
    });
  }

  Future<void> _submitAnswers() async {
    final prefs = await SharedPreferences.getInstance();

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final correctOption = _questions[i]['correctOption'];
      if (correctOption != null && _selectedAnswers[i] == correctOption) {
        score += 1; // Each question is worth 1 point
      }
    }

    setState(() {
      _attemptsLeft -= 1;
      _isSubmitted = _attemptsLeft <= 0;
    });

    await prefs.setInt('${widget.subjectName}_attemptsLeft', _attemptsLeft);
    await prefs.setBool('${widget.subjectName}_submitted', _isSubmitted);

    _showResultDialog(score);
  }

  void _showResultDialog(int score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('You are awesome!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: $score/${_questions.length}'),
              const SizedBox(height: 10),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final correctOption = question['correctOption'];
                final isCorrect = _selectedAnswers[index] == correctOption;
                return ListTile(
                  title: Text(
                    'Q${index + 1}: ${question['question']}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Your answer: ${_selectedAnswers[index] != null ? question['options'][_selectedAnswers[index]!] : "Not answered"}'),
                      Text('Correct answer: ${correctOption != null ? question['options'][correctOption] : "Not available"}'),
                    ],
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_attemptsLeft <= 0) {
                  Navigator.of(context).pop(); // Go back to the previous screen if no attempts left
                }
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
          : (_isSubmitted && _attemptsLeft <= 0)
              ? Center(
                  child: Text(
                    'You have used all your attempts for this test.',
                    style: GoogleFonts.openSans(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
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
                                    _selectedAnswers[index] = value;
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
      floatingActionButton: (_isSubmitted && _attemptsLeft <= 0) || _selectedAnswers.length < _questions.length
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