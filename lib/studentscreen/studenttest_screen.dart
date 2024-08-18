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
            'correctOption': questionData['correctOption'],
          };
        }).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkIfSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSubmitted = prefs.getBool('${widget.subjectName}_submitted') ?? false;
    });
  }

  Future<void> _submitAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.subjectName}_submitted', true);

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctOption']) {
        score += 10; // Assuming each question is worth 10 points
      }
    }

    _showScoreDialog(score);
  }

  void _showScoreDialog(int score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('You are awesome!'),
          content: Text('Score $score'),
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
          : _isSubmitted
              ? Center(
                  child: Text(
                    'You have already submitted the test for this subject.',
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
      floatingActionButton: _isSubmitted || _selectedAnswers.length < _questions.length
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
