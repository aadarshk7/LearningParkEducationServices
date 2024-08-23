import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningparkeducation/teacherscreen2/add_teachers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _GetUserState createState() => _GetUserState();
}

class _GetUserState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';

  // Method to delete user from Firebase Authentication
  Future<void> deleteUserFromFirebaseAuth(String email) async {
    try {
      var snapshot = await _firestore
          .collection('teachers')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // String uid = snapshot.docs.first.id;
        await _auth.currentUser?.delete();
        print("User with email $email deleted from Firebase Authentication.");
      } else {
        print("No user found with email: $email");
      }
    } catch (e) {
      print('Error deleting user from Firebase Authentication: $e');
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
              "Staff",
              style: GoogleFonts.openSans(
                fontSize: titleFontSize,
                color: Colors.lightBlue.shade900,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.blue, Colors.green],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    "Staff and Teachers:",
                    style: TextStyle(
                      fontSize: isTablet ? 45 : 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.search_sharp),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('teachers')
                      .orderBy('name')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var filteredDocs = snapshot.data!.docs.where((document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String name = data['name']?.toLowerCase() ?? '';
                      return name.contains(searchQuery);
                    }).toList();

                    return ListView(
                      padding: EdgeInsets.all(cardPadding),
                      children: filteredDocs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return Card(
                          elevation: 8,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cardRadius),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.all(cardPadding),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.lightBlue,
                                        Colors.blueAccent
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'No Name',
                                        style: GoogleFonts.openSans(
                                          fontSize: subtitleFontSize,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (data['email'] != null &&
                                          data['email'] != '')
                                        Text(
                                          data['email'] ?? 'No Email',
                                          style: GoogleFonts.openSans(
                                            fontSize: subtitleFontSize - 2,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      if (data['phoneNumber'] != null &&
                                          data['phoneNumber'] != '')
                                        Text(
                                          'Phone: ${data['phoneNumber']}',
                                          style: GoogleFonts.openSans(
                                            fontSize: subtitleFontSize - 2,
                                            color: Colors.black54,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final formKey = GlobalKey<FormState>();
                                        return AlertDialog(
                                          // title: const Text('Options'),
                                          content: Form(
                                            key: formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                // TextFormField(
                                                //   decoration:
                                                //       const InputDecoration(
                                                //           labelText:
                                                //               'New Name'),
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Please enter a name';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   onSaved: (value) {
                                                //     newName = value!;
                                                //   },
                                                // ),
                                                // TextFormField(
                                                //   decoration:
                                                //       const InputDecoration(
                                                //           labelText:
                                                //               'New Email'),
                                                //   validator: (value) {
                                                //     if (value == null ||
                                                //         value.isEmpty) {
                                                //       return 'Please enter an email';
                                                //     }
                                                //     return null;
                                                //   },
                                                //   onSaved: (value) {
                                                //     newEmail = value!;
                                                //   },
                                                // ),
                                                // OutlinedButton(
                                                //   child:
                                                //       const Text('Change Name & Email'),
                                                //   onPressed: () {
                                                //     if (formKey.currentState!
                                                //         .validate()) {
                                                //       formKey.currentState!
                                                //           .save();
                                                //       void updateUser(
                                                //           String oldEmail,
                                                //           String newName,
                                                //           String
                                                //               newEmail) async {
                                                //         var snapshot =
                                                //             await _firestore
                                                //                 .collection(
                                                //                     'teachers')
                                                //                 .where('email',
                                                //                     isEqualTo:
                                                //                         oldEmail)
                                                //                 .get();
                                                //         for (var document
                                                //             in snapshot.docs) {
                                                //           document.reference
                                                //               .update({
                                                //             'name': newName,
                                                //             'email': newEmail,
                                                //           });
                                                //         }
                                                //       }
                                                //
                                                //       updateUser(data['email'],
                                                //           newName, newEmail);
                                                //       Navigator.of(context)
                                                //           .pop();
                                                //     }
                                                //   },
                                                // ),
                                                OutlinedButton(
                                                  child: const Text(
                                                    'Delete Staff/Teacher',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    void deleteUser(
                                                        String email) async {
                                                      try {
                                                        var snapshot =
                                                            await _firestore
                                                                .collection(
                                                                    'teachers')
                                                                .where('email',
                                                                    isEqualTo:
                                                                        email)
                                                                .get();
                                                        if (snapshot
                                                            .docs.isEmpty) {
                                                          print(
                                                              'No document found for email: $email');
                                                          return;
                                                        }

                                                        for (var document
                                                            in snapshot.docs) {
                                                          if (document.exists) {
                                                            await document
                                                                .reference
                                                                .delete();
                                                            print(
                                                                "Staff document deleted successfully.");

                                                            await deleteUserFromFirebaseAuth(
                                                                email);
                                                          }
                                                        }
                                                      } catch (e) {
                                                        print(
                                                            'Error deleting user: $e');
                                                      }
                                                    }

                                                    deleteUser(data['email']);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTeachers()),
              );
            },
            label: Text(
              "Add new Staff and Teachers",
              style: GoogleFonts.openSans(
                fontSize: isTablet ? 30 : 25,
                color: Colors.lightBlue.shade900,
              ),
            ),
          ),
        );
      },
    );
  }
}
