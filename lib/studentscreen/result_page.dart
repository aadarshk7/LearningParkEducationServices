import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final List<Map<String, dynamic>> questions;
  final Map<int, int> selectedAnswers;

  const ResultPage({super.key, 
    required this.score,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        automaticallyImplyLeading: false, // Disable the default back button
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Navigate back to StudentHomepage
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Your score is $score/${questions.length}.',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          const Text('Correct Answers:', style: TextStyle(fontSize: 18)),
          ...questions.asMap().entries.map((entry) {
            int index = entry.key;
            var question = entry.value;
            return ListTile(
              title: Text('Q${index + 1}. ${question['question']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Your Answer: ${selectedAnswers[index] != null ? question['options'][selectedAnswers[index]!] : "Not Answered"}'),
                  Text(
                      'Correct Answer: ${question['options'][int.parse(question['correctOption'].replaceAll(RegExp(r'[^0-9]'), '')) - 1]}'),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to StudentHomepage
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Homepage'),
            ),
          ),
        ],
      ),
    );
  }
}
