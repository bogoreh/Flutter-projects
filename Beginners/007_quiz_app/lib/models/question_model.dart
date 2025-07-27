class Question {
  final String questionText;
  final List<Option> options;
  final String explanation;

  Question({
    required this.questionText,
    required this.options,
    required this.explanation,
  });
}

class Option {
  final String text;
  final bool isCorrect;

  Option({required this.text, required this.isCorrect});
}