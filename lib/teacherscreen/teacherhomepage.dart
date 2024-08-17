// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class TeacherHomePage extends StatefulWidget {
//   @override
//   _TeacherHomePageState createState() => _TeacherHomePageState();
// }
//
// class _TeacherHomePageState extends State<TeacherHomePage> {
//   int currentPageIndex = 0;
//   final DatabaseReference _questionsRef =
//       FirebaseDatabase.instance.ref().child('questions');
//
//   static const List<String> _subjectNames = [
//     'Account',
//     'Finance',
//     'Economics',
//   ];
//
//   static const List<Widget> _widgetOptions = [
//     Text('Subjects'),
//     Text('Marks'),
//     Text('Users'),
//     Text('Settings'),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       currentPageIndex = index;
//     });
//   }
//
//   void _openSubjectPage(BuildContext context, String subjectName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SubjectPage(
//           subjectName: subjectName,
//           questionsRef: _questionsRef.child(subjectName),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Teacher Dashboard'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 // Handle Settings
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 // Handle Logout
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: currentPageIndex == 0
//             ? ListView.builder(
//                 itemCount: _subjectNames.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_subjectNames[index]),
//                     onTap: () {
//                       _openSubjectPage(context, _subjectNames[index]);
//                     },
//                   );
//                 },
//               )
//             : _widgetOptions.elementAt(currentPageIndex),
//       ),
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: _onItemTapped,
//         selectedIndex: currentPageIndex,
//         indicatorColor: Colors.amber,
//         destinations: const <NavigationDestination>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.book),
//             icon: Icon(Icons.book_outlined),
//             label: 'Subjects',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.bar_chart),
//             icon: Icon(Icons.bar_chart_outlined),
//             label: 'Marks',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.person),
//             icon: Icon(Icons.person_outline),
//             label: 'Users',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(Icons.settings),
//             icon: Icon(Icons.settings_outlined),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SubjectPage extends StatefulWidget {
//   final String subjectName;
//   final DatabaseReference questionsRef;
//
//   SubjectPage({required this.subjectName, required this.questionsRef});
//
//   @override
//   _SubjectPageState createState() => _SubjectPageState();
// }
//
// class _SubjectPageState extends State<SubjectPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _questionController = TextEditingController();
//   final List<TextEditingController> _optionControllers =
//       List.generate(4, (index) => TextEditingController());
//   String? _correctOption;
//
//   void _addQuestion() {
//     if (_formKey.currentState!.validate() && _correctOption != null) {
//       widget.questionsRef.push().set({
//         'question': _questionController.text,
//         'options':
//             _optionControllers.map((controller) => controller.text).toList(),
//         'correctOption': _correctOption,
//       });
//
//       // After adding the question, navigate to the AccountQuestion page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               AccountQuestionPage(subjectName: widget.subjectName),
//         ),
//       );
//
//       _questionController.clear();
//       _optionControllers.forEach((controller) => controller.clear());
//       setState(() {
//         _correctOption = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.subjectName} Questions'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _questionController,
//                   decoration: InputDecoration(labelText: 'Question'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a question';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 ...List.generate(4, (index) {
//                   return Column(
//                     children: [
//                       TextFormField(
//                         controller: _optionControllers[index],
//                         decoration:
//                             InputDecoration(labelText: 'Option ${index + 1}'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter an option';
//                           }
//                           return null;
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: Text('Correct'),
//                         value: 'Option ${index + 1}',
//                         groupValue: _correctOption,
//                         onChanged: (value) {
//                           setState(() {
//                             _correctOption = value;
//                           });
//                         },
//                       ),
//                     ],
//                   );
//                 }),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _addQuestion,
//                   child: Text('Add Question'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AccountQuestionPage extends StatelessWidget {
//   final String subjectName;
//
//   AccountQuestionPage({required this.subjectName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$subjectName Questions'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseDatabase.instance
//             .ref()
//             .child('questions')
//             .child(subjectName)
//             .onValue,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//             return Center(child: Text('No questions found.'));
//           }
//
//           Object? questions = snapshot.data?.snapshot.value;
//           List<Question> questionList = (questions as Map<dynamic, dynamic>)
//               .entries
//               .map((entry) =>
//                   Question.fromMap(Map<String, dynamic>.from(entry.value)))
//               .toList();
//
//           return ListView.builder(
//             itemCount: questionList.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(questionList[index].question),
//                 subtitle: Text(
//                     'Correct Option: ${questionList[index].correctOption}'),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Accounts',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Finance',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Economics',
//           ),
//         ],
//         onTap: (index) {
//           String selectedSubject = subjectName[index];
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   AccountQuestionPage(subjectName: selectedSubject),
//             ),
//           );
//         },
//         currentIndex: subjectName.indexOf(subjectName),
//       ),
//     );
//   }
// }
//
// class Question {
//   final String question;
//   final List<String> options;
//   final String correctOption;
//
//   Question(
//       {required this.question,
//       required this.options,
//       required this.correctOption});
//
//   factory Question.fromMap(Map<String, dynamic> map) {
//     return Question(
//       question: map['question'],
//       options: List<String>.from(map['options']),
//       correctOption: map['correctOption'],
//     );
//   }
// }
