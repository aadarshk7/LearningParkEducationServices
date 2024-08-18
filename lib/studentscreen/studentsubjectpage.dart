import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class Studentsubjectpage extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  Studentsubjectpage({required this.subjectName, required this.questionsRef});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<Studentsubjectpage> {
  List<Map<String, dynamic>> questions = [];
  Map<int, int> selectedAnswers = {};
  List<Map<String, dynamic>> filteredQuestions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    searchController.addListener(_filterQuestions);
  }

  void _fetchQuestions() async {
    DataSnapshot snapshot = await widget.questionsRef.get();
    List<Map<String, dynamic>> loadedQuestions = [];

    snapshot.children.forEach((questionSnapshot) {
      Map<String, dynamic> questionData = Map<String, dynamic>.from(questionSnapshot.value as Map);
      loadedQuestions.add(questionData);
    });

    setState(() {
      questions = loadedQuestions;
      filteredQuestions = loadedQuestions;
    });
  }

  void _filterQuestions() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredQuestions = questions.where((question) {
        return question['question'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _submitAnswers() {
    int correctAnswers = 0;
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == questions[i]['correctOption']) {
        correctAnswers++;
      }
    }

    // Store marks in Firebase under student name and Gmail
    DatabaseReference marksRef = FirebaseDatabase.instance.ref().child('marks');
    marksRef.push().set({
      'studentGmail': 'student@example.com', // Replace with actual student Gmail
      'studentName': 'Student Name', // Replace with actual student name
      'marks': correctAnswers,
    });

    // Navigate back to homepage
    Navigator.pop(context);
  }

  void _showFeedback(bool isCorrect) {
    final snackBar = SnackBar(
      content: Text(
        isCorrect ? 'Correct!' : 'Incorrect!',
        style: GoogleFonts.openSans(),
      ),
      backgroundColor: isCorrect ? Colors.black : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subjectName + " Questions",
          style: GoogleFonts.openSans(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Questions',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredQuestions.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredQuestions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(filteredQuestions[index]['question']),
                          subtitle: Column(
                            children: List.generate(filteredQuestions[index]['options'].length, (optionIndex) {
                              return RadioListTile(
                                title: Text(filteredQuestions[index]['options'][optionIndex]),
                                value: optionIndex,
                                groupValue: selectedAnswers[index],
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedAnswers[index] = value!;
                                    _showFeedback(value == filteredQuestions[index]['correctOption']);
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: questions.length >= 10
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitAnswers,
                child: Text("Submit"),
              ),
            )
          : null,
    );
  }
}