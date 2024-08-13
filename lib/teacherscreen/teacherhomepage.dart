import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learningparkeducation/teacherscreen/userpage.dart';
import '../studentscreen/studentssubject_list.dart';
import 'subject_page.dart' as teacher;

class TeacherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard', style: TextStyle(fontSize: 24)),
        actions: [Icon(Icons.person), Icon(Icons.settings)],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(users[index]['name'],
                          style: TextStyle(fontSize: 18)),
                      trailing: Text('Marks: ${users[index]['marks']}',
                          style: TextStyle(fontSize: 18)),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSubjectCard(context, 'Account', 'account_bg.png'),
                _buildSubjectCard(context, 'Finance', 'finance_bg.png'),
                _buildSubjectCard(context, 'Economics', 'economics_bg.png'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  UserPage(subjectName: 'Finance')));
        },
      ),
    );
  }

  Widget _buildSubjectCard(
      BuildContext context, String subjectName, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => teacher.SubjectPage(subjectName: subjectName),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$imagePath'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(subjectName,
              style: TextStyle(fontSize: 22, color: Colors.white)),
        ),
      ),
    );
  }
}
