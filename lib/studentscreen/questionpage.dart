import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class QuestionsPage extends StatefulWidget {
  final String subjectName;

  const QuestionsPage({super.key, required this.subjectName});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final DatabaseReference _questionsRef =
      FirebaseDatabase.instance.ref().child('questions');
  List<Question> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() {
    _questionsRef.child(widget.subjectName).onValue.listen((event) {
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
        });
      } else {
        setState(() {
          _questions = [];
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} Questions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text('No questions available.'))
              : ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return ListTile(
                      title: Text(question.question ?? 'No question text'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...?question.options?.asMap().entries.map((entry) {
                            int idx = entry.key + 1;
                            String option = entry.value;
                            return Text('$idx. $option');
                          }),
                          Text(
                              'Correct Option: ${question.correctOption ?? 'N/A'}'),
                        ],
                      ),
                    );
                  },
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
