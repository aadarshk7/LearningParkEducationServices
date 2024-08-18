import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:learningparkeducation/adminpage/adminuserpage.dart';
import 'package:learningparkeducation/teacherscreen2/subjectpage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'studenttest_screen.dart';

class StudentHomepage extends StatefulWidget {
  @override
  _StudentHomepageState createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  int currentPageIndex = 0;
  final DatabaseReference _questionsRef =
      FirebaseDatabase.instance.ref().child('questions');
      // final DatabaseReference _questionsRef = FirebaseDatabase.instance.reference().child('questions');


  static const List<String> _subjectNames = [
    'Account',
    'Finance',
    'Economics',
  ];

  static const List<String> _widgetOptions = [
    'Subjects',
    'Marks',
    'Users',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });

    // Navigate to the Users screen if the index is 2
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GetUser()),
      );
    }
  }

  // void _openSubjectPage(BuildContext context, String subjectName) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SubjectPage(
  //         subjectName: subjectName,
  //         questionsRef: _questionsRef.child(subjectName),
  //       ),
  //     ),
  //   );
  // }


// void _openSubjectPage(BuildContext context, String subjectName) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => StudentTestPage(
//         subjectName: subjectName,
//         questionsRef: _questionsRef.child(subjectName),
//       ),
//     ),
//   );
// }



// void _openSubjectPage(BuildContext context, String subjectName) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => StudentTestPage(
//         subjectName: subjectName,
//       ),
//     ),
//   );
// }

void _openSubjectPage(BuildContext context, String subjectName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StudentTestPage(
        subjectName: subjectName,
        questionsRef: _questionsRef.child(subjectName), // Ensure _questionsRef is defined
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome Student',
          style: GoogleFonts.openSans(),
        ),
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
              title: Text(
                'Settings',
                style: GoogleFonts.openSans(),
              ),
              onTap: () {
                // Handle Settings
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: GoogleFonts.openSans(),
              ),
              onTap: () {
                // Handle Logout
              },
            ),
          ],
        ),
      ),
      body: currentPageIndex == 0
          ? ListView.builder(
              itemCount: _subjectNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _subjectNames[index],
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        _openSubjectPage(context, _subjectNames[index]);
                      },
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                _widgetOptions[currentPageIndex],
                style: TextStyle(fontSize: 30),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
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