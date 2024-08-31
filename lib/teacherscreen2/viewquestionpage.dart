import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:learningparkeducation/teacherscreen2/editquestionpage.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewQuestionsPage extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  const ViewQuestionsPage(
      {super.key, required this.subjectName, required this.questionsRef});

  @override
  _ViewQuestionsPageState createState() => _ViewQuestionsPageState();
}

class _ViewQuestionsPageState extends State<ViewQuestionsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Question> _filteredQuestions = [];
  List<Question> _questionList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.questionsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> questions =
            event.snapshot.value as Map<dynamic, dynamic>;
        _questionList = questions.entries
            .map((entry) => Question.fromMap(
                Map<String, dynamic>.from(entry.value), entry.key))
            .where((question) => question != null)
            .toList();

        _questionList
            .sort((a, b) => a.question?.compareTo(b.question ?? '') ?? 0);

        setState(() {
          _filteredQuestions = _questionList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _filteredQuestions = [];
          _isLoading = false;
        });
      }
    });
  }

  void _filterQuestions(String query) {
    List<Question> results = [];
    if (query.isEmpty) {
      results = _questionList;
    } else {
      results = _questionList
          .where((q) =>
              (q.question ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredQuestions = results;
    });
  }

  void _deleteQuestion(String id) {
    widget.questionsRef.child(id).remove().then((_) {
      setState(() {
        _filteredQuestions.removeWhere((question) => question.id == id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subjectName} Questions',
          style: GoogleFonts.openSans(),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _filterQuestions(value),
                    decoration: InputDecoration(
                      hintText: 'Search Questions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: GoogleFonts.openSans(),
                  ),
                ),
                Expanded(
                  child: _filteredQuestions.isEmpty
                      ? Center(
                          child: Text('No questions found.',
                              style: GoogleFonts.openSans()))
                      : ListView.builder(
                          itemCount: _filteredQuestions.length,
                          itemBuilder: (context, index) {
                            final question = _filteredQuestions[index];
                            return ListTile(
                              title: Text(
                                question.question ?? 'No question text',
                                style: GoogleFonts.openSans(),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...?question.options
                                      ?.asMap()
                                      .entries
                                      .map((entry) {
                                    int idx = entry.key + 1;
                                    String option = entry.value;
                                    return Text('$idx. $option',
                                        style: GoogleFonts.openSans());
                                  }),
                                  Text(
                                    'Correct Option: ${question.correctOption ?? 'N/A'}',
                                    style: GoogleFonts.openSans(),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditQuestionPage(
                                            subjectName: widget.subjectName,
                                            questionId: question.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteQuestion(question.id),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
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
      id: id, // Use the Firebase key as the id
      question: map['question'] as String?,
      options:
          map['options'] != null ? List<String>.from(map['options']) : null,
      correctOption: map['correctOption'] as String?,
    );
  }
}
