import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningparkeducation/studentscreen/quotespage.dart';
import 'package:learningparkeducation/studentscreen/studenttest_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../chatbot/chat_screen.dart';
import '../choice_screen.dart'; // Import the ChoicePage
import '../screens/login_screen.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  _StudentHomepageState createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  int currentPageIndex = 0;
  final DatabaseReference _subjectsRef =
      FirebaseDatabase.instance.ref().child('subjects');
  final DatabaseReference _questionsRef =
      FirebaseDatabase.instance.ref().child('questions');
  String studentName = "Loading...";
  String studentEmail = "Loading...";
  List<String> _subjectNames = [];
  bool _showNoNameDialog = false; // Flag to track if dialog should be shown
  bool _isLoading = true; // Flag to track loading state for student details
  bool _areSubjectsLoading = true; // Flag to track loading state for subjects

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus(); // Check user login status on init
    _fetchStudentName();
    _fetchSubjects();
  }

  Future<void> _checkUserLoginStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null || user.email!.isEmpty) {
      // User is not logged in or email is empty
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChoicePage()),
      );
    } else {
      // User is logged in, proceed to fetch student details
      _fetchStudentName();
      _fetchSubjects();
    }
  }

  Future<void> _fetchStudentName() async {
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
            studentEmail = doc.data()['email'] ?? 'No email found';
            _showNoNameDialog =
                studentName == 'No name found'; // Show dialog if no name found
            _isLoading =
                false; // Set loading flag to false when data is fetched
          });
        } else {
          setState(() {
            studentName = 'No name found';
            studentEmail = 'No email found';
            _showNoNameDialog = true; // Show dialog if no name found
            _isLoading =
                false; // Set loading flag to false when data is fetched
          });
        }
      } catch (e) {
        print("Error fetching student name: $e");
        setState(() {
          studentName = 'Error loading name';
          studentEmail = 'Error loading email';
          _isLoading = false; // Set loading flag to false in case of error
        });
      }
    } else {
      setState(() {
        studentName = 'User not logged in';
        studentEmail = 'No email found';
        _isLoading = false; // Set loading flag to false if no user is logged in
      });
    }
  }

  Future<void> _fetchSubjects() async {
    _subjectsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _subjectNames = data.values.map((e) => e.toString()).toList();
          _subjectNames.sort(); // Sort subjects alphabetically
          _areSubjectsLoading =
              false; // Set loading flag to false when data is fetched
        });
      } else {
        setState(() {
          _areSubjectsLoading = false; // Set loading flag to false if no data
        });
      }
    });
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < 2) {
      setState(() {
        currentPageIndex = index;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out. Please try again.'),
        ),
      );
    }
  }

  Future<void> _launchDeveloperSite() async {
    const url = 'https://solo.to/aadarshk7'; // Replace with the actual URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch the developer site.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentPageIndex >= 2) {
      currentPageIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MCQ App',
          style: GoogleFonts.openSans(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $studentName',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    studentEmail,
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.format_quote),
              title: Text(
                'Quotes',
                style: GoogleFonts.openSans(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuotesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: Text(
                'AI Chatbot',
                style: GoogleFonts.openSans(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.developer_mode),
              title: Text(
                'About: Dev Profile',
                style: GoogleFonts.openSans(),
              ),
              onTap: _launchDeveloperSite,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'Logout',
                style: GoogleFonts.openSans(),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 5, 5),
            child: Text(
              'Welcome, \n $studentName',
              style: GoogleFonts.openSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              'Select a subject to start the test:',
              style: GoogleFonts.openSans(
                fontSize: 22,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 22),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading && _areSubjectsLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading && !_areSubjectsLoading)
            Expanded(
              child: ListView.builder(
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
              ),
            ),
          if (!_isLoading && !_areSubjectsLoading && _subjectNames.isEmpty)
            Center(
              child: Text(
                'No subjects available.',
                style: GoogleFonts.openSans(fontSize: 18, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  void _openSubjectPage(BuildContext context, String subjectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentTestPage(
          subjectName: subjectName,
          questionsRef: _questionsRef,
          subject: '',
        ),
      ),
    );
  }
}
