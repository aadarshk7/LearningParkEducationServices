import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String studentName = "Loading...";

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

  @override
  void initState() {
    super.initState();
    _fetchStudentName();
  }

  void _fetchStudentName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final email = user.email;
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          setState(() {
            studentName = doc.data()['name'] ?? 'No name found';
          });
        } else {
          setState(() {
            studentName = 'No name found';
          });
        }
      } catch (e) {
        print("Error fetching student name: $e");
        setState(() {
          studentName = 'Error loading name';
        });
      }
    } else {
      setState(() {
        studentName = 'User not logged in';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GetUser()),
      );
    }
  }

  void _openSubjectPage(BuildContext context, String subjectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentTestPage(
          subjectName: subjectName,
          questionsRef: _questionsRef.child(subjectName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $studentName',
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
