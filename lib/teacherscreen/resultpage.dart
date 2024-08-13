import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results', style: TextStyle(fontSize: 24)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title:
                    Text(users[index]['name'], style: TextStyle(fontSize: 18)),
                trailing: Text('Marks: ${users[index]['marks']}',
                    style: TextStyle(fontSize: 18)),
              );
            },
          );
        },
      ),
    );
  }
}
