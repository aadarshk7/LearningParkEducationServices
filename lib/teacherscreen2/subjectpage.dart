import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:learningparkeducation/teacherscreen2/viewquestionpage.dart';

class SubjectPage extends StatefulWidget {
  final String subjectName;
  final DatabaseReference questionsRef;

  const SubjectPage({super.key, required this.subjectName, required this.questionsRef});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (index) => TextEditingController());
  String? _correctOption;

  void _addQuestion() {
    if (_formKey.currentState!.validate() && _correctOption != null) {
      widget.questionsRef.push().set({
        'question': _questionController.text,
        'options':
            _optionControllers.map((controller) => controller.text).toList(),
        'correctOption': _correctOption,
      });

      _questionController.clear();
      for (var controller in _optionControllers) {
        controller.clear();
      }
      setState(() {
        _correctOption = null;
      });
    }
  }

  void _viewQuestions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewQuestionsPage(
          subjectName: widget.subjectName,
          questionsRef: widget.questionsRef,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} Questions'),
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
                      onPressed: _addQuestion,
                      child: const Text('Add Question'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _viewQuestions,
                      child: const Text('View Questions'),
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
