import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(fontSize: 24)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title:
                    Text(users[index]['name'], style: const TextStyle(fontSize: 18)),
                trailing: Text('Marks: ${users[index]['marks']}',
                    style: const TextStyle(fontSize: 18)),
              );
            },
          );
        },
      ),
    );
  }
}
