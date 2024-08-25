// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class StudentTestPage extends StatefulWidget {
//   final String subjectName;
//   final DatabaseReference questionsRef;
//   final String studentId; // Add a student ID to track attempts
//
//   StudentTestPage({
//     required this.subjectName,
//     required this.questionsRef,
//     required this.studentId,
//   });
//
//   @override
//   _StudentTestPageState createState() => _StudentTestPageState();
// }
//
// class _StudentTestPageState extends State<StudentTestPage> {
//   List<Map<String, dynamic>> _questions = [];
//   Map<String, String?> _selectedAnswers = {};
//   bool _isLoading = true;
//   int _attempts = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadQuestions();
//   }
//
//   void _loadQuestions() async {
//     // Check how many attempts the student has already made
//     DatabaseReference attemptsRef = FirebaseDatabase.instance
//         .ref()
//         .child('attempts')
//         .child(widget.studentId)
//         .child(widget.subjectName);
//
//     DataSnapshot attemptsSnapshot = await attemptsRef.get();
//     _attempts = attemptsSnapshot.value as int? ?? 0;
//
//     if (_attempts >= 3) {
//       // Show a dialog that the student cannot take the test again
//       _showMaxAttemptsDialog();
//       return;
//     }
//
//     DataSnapshot snapshot = await widget.questionsRef.get();
//     List<Map<String, dynamic>> questions = [];
//     for (DataSnapshot child in snapshot.children) {
//       questions.add(Map<String, dynamic>.from(child.value as Map));
//     }
//     setState(() {
//       _questions = questions;
//       _isLoading = false;
//     });
//   }
//
//   void _showMaxAttemptsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Maximum Attempts Reached"),
//           content: Text("You have already taken this test 3 times."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context); // Go back to the previous screen
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _handleSubmit() async {
//     int score = 0;
//
//     for (var question in _questions) {
//       if (_selectedAnswers[question['id']] == question['correctOption']) {
//         score += 1;
//       }
//     }
//
//     // Update attempts count
//     DatabaseReference attemptsRef = FirebaseDatabase.instance
//         .ref()
//         .child('attempts')
//         .child(widget.studentId)
//         .child(widget.subjectName);
//
//     await attemptsRef.set(_attempts + 1);
//
//     // Show score to the student
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Test Completed"),
//           content: Text("Your score is $score/${_questions.length}"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context); // Go back to the previous screen
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.subjectName, style: GoogleFonts.openSans()),
//         ),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.subjectName, style: GoogleFonts.openSans()),
//       ),
//       body: ListView.builder(
//         itemCount: _questions.length,
//         itemBuilder: (context, index) {
//           var question = _questions[index];
//           return Card(
//             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Q${index + 1}. ${question['question']}",
//                     style: GoogleFonts.openSans(fontSize: 18),
//                   ),
//                   for (var option in question['options'])
//                     RadioListTile<String?>(
//                       title: Text(option),
//                       value: option,
//                       groupValue: _selectedAnswers[question['id']],
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedAnswers[question['id']] = value;
//                         });
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: _selectedAnswers.length == _questions.length
//               ? _handleSubmit
//               : null, // Disable button if not all questions are answered
//           child: Text("Submit"),
//         ),
//       ),
//     );
//   }
// }
