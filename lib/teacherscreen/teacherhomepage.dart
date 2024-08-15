import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int currentPageIndex = 0; // Updated to match NavigationBarApp style
  final DatabaseReference _questionsRef =
      FirebaseDatabase.instance.ref().child('questions');

  static const List<String> _subjectNames = [
    'Account',
    'Finance',
    'Economics',
  ];

  static const List<Widget> _widgetOptions = [
    Text('Subjects'),
    Text('Marks'),
    Text('Users'),
    Text('Settings'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index; // Updated to match NavigationBarApp style
    });
  }

  void _openSubjectPage(BuildContext context, String subjectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectPage(
          subjectName: subjectName,
          questionsRef: _questionsRef.child(subjectName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle Settings
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle Logout
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: currentPageIndex == 0
            ? ListView.builder(
                itemCount: _subjectNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_subjectNames[index]),
                    onTap: () {
                      _openSubjectPage(context, _subjectNames[index]);
                    },
                  );
                },
              )
            : _widgetOptions.elementAt(currentPageIndex),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped, // Updated to use NavigationBar
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.amber,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'Subjects',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bar_chart),
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Marks',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Users',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class SubjectPage extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  SubjectPage({required this.subjectName, required this.questionsRef});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (index) => TextEditingController());
  String? _correctOption;

  void _addQuestion() {
    if (_formKey.currentState!.validate() && _correctOption != null) {
      widget.questionsRef.push().set({
        'question': _questionController.text,
        'options':
            _optionControllers.map((controller) => controller.text).toList(),
        'correctOption': _correctOption,
      });
      _questionController.clear();
      _optionControllers.forEach((controller) => controller.clear());
      setState(() {
        _correctOption = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} Questions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(labelText: 'Question'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ...List.generate(4, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: _optionControllers[index],
                        decoration:
                            InputDecoration(labelText: 'Option ${index + 1}'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an option';
                          }
                          return null;
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Correct'),
                        value: 'Option ${index + 1}',
                        groupValue: _correctOption,
                        onChanged: (value) {
                          setState(() {
                            _correctOption = value;
                          });
                        },
                      ),
                    ],
                  );
                }),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text('Add Question'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
