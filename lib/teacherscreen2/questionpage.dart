class Question {
  final String id;
  final String question;
  final List<String> options;
  final String correctOption;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOption,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      options: List<String>.from(map['options']),
      correctOption: map['correctOption'],
    );
  }
}