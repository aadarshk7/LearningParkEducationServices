import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningparkeducation/choice_screen.dart';
import 'package:learningparkeducation/teacherscreen2/settings_page.dart';
import 'package:learningparkeducation/teacherscreen2/subjectpage.dart';
import 'package:learningparkeducation/teacherscreen2/teacher_login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../adminpage/student_list.dart';
import '../chatbot/chat_screen.dart';
import '../studentscreen/quotespage.dart';
import 'marks_page.dart'; // Import the new MarksPage

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  bool isLoading = true; // Add this line to manage loading state
  int currentPageIndex = 0;
  final DatabaseReference _subjectsRef =
      FirebaseDatabase.instance.ref().child('subjects');
  List<String> _subjectNames = [];
  String staffName = "Loading...";
  String studentEmail = "Loading...";
  String staffEmail = "Loading...";
  bool _isLoading = true;
  bool _showNoNameDialog = false;

  static const List<String> _widgetOptions = [
    'Subjects',
    '',
    '',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
    _staffName();
  }

  Future<void> _staffName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final email = user.email;
        final querySnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          setState(() {
            staffName = doc.data()['name'] ?? 'No name found';
            staffEmail = doc.data()['email'] ?? 'No email found';
            _showNoNameDialog =
                staffName == 'No name found'; // Show dialog if no name found
            _isLoading =
                false; // Set loading flag to false when data is fetched
          });
        } else {
          setState(() {
            staffName = 'No name found';
            staffEmail = 'No email found';
            _showNoNameDialog = true; // Show dialog if no name found
            _isLoading =
                false; // Set loading flag to false when data is fetched
          });
        }
      } catch (e) {
        print("Error fetching Staff name: $e");
        setState(() {
          staffName = 'Error loading name';
          staffEmail = 'Error loading email';
          _isLoading = false; // Set loading flag to false in case of error
        });
      }
    } else {
      setState(() {
        staffName = 'Staff not logged in';
        staffEmail = 'No email found';
        _isLoading = false; // Set loading flag to false if no user is logged in
      });
    }
  }

  // Future<void> _fetchStudentName() async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       final email = user.email;
  //       final querySnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where('email', isEqualTo: email)
  //           .get();
  //
  //       if (querySnapshot.docs.isNotEmpty) {
  //         final doc = querySnapshot.docs.first;
  //         setState(() {
  //           studentName = doc.data()['name'] ?? 'No name found';
  //           studentEmail = doc.data()['email'] ?? 'No email found';
  //           _showNoNameDialog =
  //               studentName == 'No name found'; // Show dialog if no name found
  //           _isLoading =
  //               false; // Set loading flag to false when data is fetched
  //         });
  //       } else {
  //         setState(() {
  //           studentName = 'No name found';
  //           studentEmail = 'No email found';
  //           _showNoNameDialog = true; // Show dialog if no name found
  //           _isLoading =
  //               false; // Set loading flag to false when data is fetched
  //         });
  //       }
  //     } catch (e) {
  //       print("Error fetching student name: $e");
  //       setState(() {
  //         studentName = 'Error loading name';
  //         studentEmail = 'Error loading email';
  //         _isLoading = false; // Set loading flag to false in case of error
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       studentName = 'User not logged in';
  //       studentEmail = 'No email found';
  //       _isLoading = false; // Set loading flag to false if no user is logged in
  //     });
  //   }
  // }

  void _fetchSubjects() async {
    _subjectsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _subjectNames = data.values.map((e) => e.toString()).toList();
          _subjectNames.sort(); // Sort subjects alphabetically
          isLoading = false; // Data fetched, stop loading
        });
      } else {
        setState(() {
          isLoading = false; // Even if no data, stop loading
        });
      }
    });
  }

// fetching subjects without loading circularprogress bar
//   void _fetchSubjects() async {
//     _subjectsRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map?;
//       if (data != null) {
//         setState(() {
//           _subjectNames = data.values.map((e) => e.toString()).toList();
//           _subjectNames.sort(); // Sort subjects alphabetically
//         });
//       }
//     });
//   }

  void _openSubjectPage(BuildContext context, String subjectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectPage(
          subjectName: subjectName,
          questionsRef: FirebaseDatabase.instance
              .ref()
              .child('questions')
              .child(subjectName),
        ),
      ),
    );
  }

  void _addSubject() async {
    String newSubjectName = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Subject'),
          content: TextField(
            onChanged: (value) {
              newSubjectName = value;
            },
            decoration: const InputDecoration(hintText: "Enter subject name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newSubjectName.isNotEmpty) {
                  await _subjectsRef.push().set(newSubjectName);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editSubject(String oldName) async {
    String newSubjectName = oldName;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Subject'),
          content: TextField(
            onChanged: (value) {
              newSubjectName = value;
            },
            controller: TextEditingController(text: oldName),
            decoration:
                const InputDecoration(hintText: "Enter new subject name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newSubjectName.isNotEmpty && newSubjectName != oldName) {
                  final subjectToEdit = _subjectNames.indexOf(oldName);
                  if (subjectToEdit != -1) {
                    final subjectId = _subjectNames[subjectToEdit];
                    await _subjectsRef
                        .orderByValue()
                        .equalTo(oldName)
                        .once()
                        .then((snapshot) {
                      final data = snapshot.snapshot.value as Map?;
                      if (data != null) {
                        final subjectKey = data.keys.first;
                        _subjectsRef.child(subjectKey).set(newSubjectName);
                      }
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSubject(String subjectName) async {
    await _subjectsRef
        .orderByValue()
        .equalTo(subjectName)
        .once()
        .then((snapshot) {
      final data = snapshot.snapshot.value as Map?;
      if (data != null) {
        final subjectKey = data.keys.first;
        _subjectsRef.child(subjectKey).remove();
      }
    });
  }

  void _onItemTapped(int index) {
    if (currentPageIndex == index)
      return; // Prevent re-navigation to the same tab

    setState(() {
      currentPageIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GetUser(),
        ),
      ).then((_) {
        setState(() {
          currentPageIndex =
              0; // Reset to default page index (Subjects) after returning
        });
      });
    } else if (index == 1) {
      // Navigate to MarksPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MarksPage()),
      ).then((_) {
        setState(() {
          currentPageIndex = 0; // Reset to default page index after returning
        });
      });
    } else if (index == 3) {
      // Navigate to SettingsPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      ).then((_) {
        setState(() {
          currentPageIndex =
              0; // Reset to default page index (Subjects) after returning
        });
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeacherLoginScreen()),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;
        double titleFontSize = isTablet ? 40 : 25;
        double subtitleFontSize = isTablet ? 20 : 18;
        double cardPadding = isTablet ? 20 : 12;
        double iconSize = isTablet ? 40 : 30;
        double cardRadius = 15;
        return Scaffold(
          appBar: AppBar(
              title: Text(
            "Welcome,  $staffName ",
            style: GoogleFonts.openSans(
              fontSize: 22,
              color: Colors.lightBlue.shade900,
              // fontWeight: FontWeight.bold,
            ),
          )),
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
                        'Hi, $staffName Sir',
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '$staffEmail',
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
          body: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(), // Show progress indicator while loading
                )
              : currentPageIndex == 0
                  ? ListView.builder(
                      itemCount: _subjectNames.length,
                      itemBuilder: (context, index) {
                        final subjectName = _subjectNames[index];
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
                                subjectName,
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editSubject(subjectName);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteSubject(subjectName);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                _openSubjectPage(context, subjectName);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        _widgetOptions[currentPageIndex],
                        style: const TextStyle(fontSize: 20),
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
                label: 'Students',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings_outlined),
                label: 'Staff/Teachers',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _addSubject,
            tooltip: 'Add Subject',
            label: Text(
              "Add Subjects",
              style: GoogleFonts.openSans(
                fontSize: isTablet ? 25 : 20,
                color: Colors.lightBlue.shade900,
              ),
            ),
          ),
        );
      },
    );
  }
}
