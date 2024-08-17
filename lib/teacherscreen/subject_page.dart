// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SubjectPage extends StatefulWidget {
//   final String subjectName;

//   SubjectPage(
//       {required this.subjectName, required DatabaseReference questionsRef});

//   @override
//   _SubjectPageState createState() => _SubjectPageState();
// }

// class _SubjectPageState extends State<SubjectPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _questionController = TextEditingController();
//   final List<TextEditingController> _optionControllers =
//       List.generate(4, (index) => TextEditingController());
//   String? _correctOption;

//   void _addQuestion() {
//     if (_formKey.currentState!.validate() && _correctOption != null) {
//       FirebaseFirestore.instance
//           .collection('subjects')
//           .doc(widget.subjectName)
//           .collection('questions')
//           .add({
//         'question': _questionController.text,
//         'options':
//             _optionControllers.map((controller) => controller.text).toList(),
//         'correctOption': _correctOption,
//       });
//       _questionController.clear();
//       _optionControllers.forEach((controller) => controller.clear());
//       setState(() {
//         _correctOption = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.subjectName, style: TextStyle(fontSize: 24)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _questionController,
//                 decoration: InputDecoration(labelText: 'Question'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a question';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               ...List.generate(4, (index) {
//                 return Column(
//                   children: [
//                     TextFormField(
//                       controller: _optionControllers[index],
//                       decoration:
//                           InputDecoration(labelText: 'Option ${index + 1}'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter an option';
//                         }
//                         return null;
//                       },
//                     ),
//                     RadioListTile<String>(
//                       title: Text('Correct'),
//                       value: 'Option ${index + 1}',
//                       groupValue: _correctOption,
//                       onChanged: (value) {
//                         setState(() {
//                           _correctOption = value;
//                         });
//                       },
//                     ),
//                   ],
//                 );
//               }),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _addQuestion,
//                 child: Text('Add Question'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
