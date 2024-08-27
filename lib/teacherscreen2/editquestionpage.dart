import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditQuestionPage extends StatefulWidget {
  final String subjectName;
  final String questionId;

  const EditQuestionPage(
      {super.key, required this.subjectName, required this.questionId});

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  late DatabaseReference _questionRef;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (index) => TextEditingController());
  String? _correctOption;

  @override
  void initState() {
    super.initState();
    _questionRef = FirebaseDatabase.instance
        .ref()
        .child('questions')
        .child(widget.subjectName)
        .child(widget.questionId);
    _loadQuestion();
  }

  void _loadQuestion() async {
    DataSnapshot snapshot = await _questionRef.get();
    Map<String, dynamic> questionData =
        Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    _questionController.text = questionData['question'];
    _correctOption = questionData['correctOption'];
    List<String> options = List<String>.from(questionData['options']);
    for (int i = 0; i < _optionControllers.length; i++) {
      _optionControllers[i].text = options[i];
    }
    setState(() {});
  }

  void _updateQuestion() {
    if (_formKey.currentState!.validate() && _correctOption != null) {
      _questionRef.update({
        'question': _questionController.text,
        'options':
            _optionControllers.map((controller) => controller.text).toList(),
        'correctOption': _correctOption,
      });

      Navigator.pop(context);
    }
  }

  void _deleteQuestion() {
    _questionRef.remove();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Question'),
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
                  decoration: const InputDecoration(labelText: 'Question'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                        title: const Text('Correct'),
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _updateQuestion,
                      child: const Text('Update Question'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _deleteQuestion,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete Question'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
