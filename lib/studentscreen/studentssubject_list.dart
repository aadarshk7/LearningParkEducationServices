import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: StudentSubjectList(),
//   ));
// }

class StudentSubjectList extends StatelessWidget {
  final List<String> subjects = [
    'Accounting',
    'Finance',
    'Economics',
    'Management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject List'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SubjectPage(subjectName: subjects[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SubjectPage extends StatefulWidget {
  final String subjectName;

  SubjectPage({required this.subjectName});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  int _selectedIndex = 0;

  final List<Map<String, Object>> accountingQuestions = [
    {
      'questionText': 'What is the primary objective of financial accounting?',
      'answers': [
        {'text': 'To determine tax liabilities', 'correct': false},
        {
          'text': 'To provide financial information to external users',
          'correct': true
        },
        {'text': 'To assist in budgeting', 'correct': false},
        {'text': 'To ensure compliance with regulations', 'correct': false},
      ],
    },
    {
      'questionText':
          'Which financial statement shows a company’s financial position at a specific point in time?',
      'answers': [
        {'text': 'Income Statement', 'correct': false},
        {'text': 'Statement of Cash Flows', 'correct': false},
        {'text': 'Balance Sheet', 'correct': true},
        {'text': 'Statement of Retained Earnings', 'correct': false},
      ],
    },
    {
      'questionText':
          'Which of the following is an example of a current asset?',
      'answers': [
        {'text': 'Land', 'correct': false},
        {'text': 'Equipment', 'correct': false},
        {'text': 'Accounts Receivable', 'correct': true},
        {'text': 'Goodwill', 'correct': false},
      ],
    },
    {
      'questionText':
          'Which accounting principle requires expenses to be recorded in the same period as the revenues they help to generate?',
      'answers': [
        {'text': 'Conservatism', 'correct': false},
        {'text': 'Matching Principle', 'correct': true},
        {'text': 'Consistency', 'correct': false},
        {'text': 'Going Concern', 'correct': false},
      ],
    },
    {
      'questionText': 'What does the term “accrual” refer to in accounting?',
      'answers': [
        {'text': 'Recording expenses when paid', 'correct': false},
        {'text': 'Recording revenues when earned', 'correct': true},
        {'text': 'Recording revenues when received', 'correct': false},
        {'text': 'Recording expenses when incurred', 'correct': false},
      ],
    },
    {
      'questionText': 'What is a liability in accounting terms?',
      'answers': [
        {'text': 'A company’s resources', 'correct': false},
        {'text': 'An obligation to pay debts', 'correct': true},
        {'text': 'A shareholder’s investment', 'correct': false},
        {'text': 'A financial gain', 'correct': false},
      ],
    },
    {
      'questionText':
          'Which of the following is NOT considered a financial statement?',
      'answers': [
        {'text': 'Balance Sheet', 'correct': false},
        {'text': 'Trial Balance', 'correct': true},
        {'text': 'Income Statement', 'correct': false},
        {'text': 'Cash Flow Statement', 'correct': false},
      ],
    },
    {
      'questionText': 'What does the term “depreciation” mean?',
      'answers': [
        {'text': 'Increase in asset value over time', 'correct': false},
        {'text': 'Decrease in liability over time', 'correct': false},
        {
          'text': 'Allocation of the cost of an asset over its useful life',
          'correct': true
        },
        {'text': 'Adjustment of accounts', 'correct': false},
      ],
    },
    {
      'questionText': 'What is the double-entry system of accounting?',
      'answers': [
        {
          'text': 'Recording transactions in a single account',
          'correct': false
        },
        {
          'text': 'Recording transactions with equal debits and credits',
          'correct': true
        },
        {'text': 'Using a cash basis for accounting', 'correct': false},
        {
          'text': 'Recording transactions once they are completed',
          'correct': false
        },
      ],
    },
    {
      'questionText':
          'Which of the following accounts increases with a credit?',
      'answers': [
        {'text': 'Assets', 'correct': false},
        {'text': 'Expenses', 'correct': false},
        {'text': 'Revenues', 'correct': true},
        {'text': 'Dividends', 'correct': false},
      ],
    },
    {
      'questionText': 'What is the purpose of a trial balance?',
      'answers': [
        {'text': 'To record daily transactions', 'correct': false},
        {
          'text': 'To show the financial position of a company',
          'correct': false
        },
        {
          'text': 'To check the equality of debits and credits',
          'correct': true
        },
        {'text': 'To report on financial performance', 'correct': false},
      ],
    },
    {
      'questionText': 'What type of account is “Accounts Payable”?',
      'answers': [
        {'text': 'Asset', 'correct': false},
        {'text': 'Liability', 'correct': true},
        {'text': 'Equity', 'correct': false},
        {'text': 'Revenue', 'correct': false},
      ],
    },
    {
      'questionText': 'What is goodwill in accounting?',
      'answers': [
        {'text': 'A type of fixed asset', 'correct': false},
        {'text': 'A tangible asset', 'correct': false},
        {'text': 'An intangible asset', 'correct': true},
        {'text': 'A financial liability', 'correct': false},
      ],
    },
    {
      'questionText': 'Which statement best describes “equity”?',
      'answers': [
        {'text': 'The amount owed by the company', 'correct': false},
        {'text': 'The value of assets owned by the company', 'correct': false},
        {'text': 'The owner’s claim on the company’s assets', 'correct': true},
        {'text': 'The company’s financial obligations', 'correct': false},
      ],
    },
    {
      'questionText': 'What is the formula for calculating net income?',
      'answers': [
        {'text': 'Total Revenue - Total Expenses', 'correct': true},
        {'text': 'Total Assets - Total Liabilities', 'correct': false},
        {'text': 'Total Equity - Total Liabilities', 'correct': false},
        {'text': 'Total Revenue + Total Expenses', 'correct': false},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeSection(questions: accountingQuestions),
          ScoreSection(),
          ProfileSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeSection extends StatelessWidget {
  final List<Map<String, Object>> questions;

  HomeSection({required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return MCQWidget(question: questions[index]);
      },
    );
  }
}

class MCQWidget extends StatefulWidget {
  final Map<String, Object> question;

  MCQWidget({required this.question});

  @override
  _MCQWidgetState createState() => _MCQWidgetState();
}

class _MCQWidgetState extends State<MCQWidget> {
  bool _answered = false;
  String _selectedAnswer = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question['questionText'] as String,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...(widget.question['answers'] as List<Map<String, Object>>)
                .map((answer) {
              return RadioListTile<String>(
                title: Text(answer['text'] as String),
                value: answer['text'] as String,
                groupValue: _selectedAnswer,
                onChanged: !_answered
                    ? (value) {
                        setState(() {
                          _selectedAnswer = value!;
                          _answered = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(answer['correct'] as bool
                                ? 'Correct!'
                                : 'Incorrect!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    : null,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ScoreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Score Section'),
    );
  }
}

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Section'),
    );
  }
}
