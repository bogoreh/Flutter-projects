import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/widgets/option_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool showAnswer = false;
  int? selectedOptionIndex;
  bool quizCompleted = false;

  final List<Question> questions = [
    Question(
      questionText: "What is the capital of France?",
      options: [
        Option(text: "London", isCorrect: false),
        Option(text: "Paris", isCorrect: true),
        Option(text: "Berlin", isCorrect: false),
        Option(text: "Madrid", isCorrect: false),
      ],
      explanation: "Paris is the capital and most populous city of France.",
    ),
    Question(
      questionText: "Which planet is known as the Red Planet?",
      options: [
        Option(text: "Venus", isCorrect: false),
        Option(text: "Mars", isCorrect: true),
        Option(text: "Jupiter", isCorrect: false),
        Option(text: "Saturn", isCorrect: false),
      ],
      explanation: "Mars is often called the 'Red Planet' because of its reddish appearance.",
    ),
    Question(
      questionText: "What is the largest mammal in the world?",
      options: [
        Option(text: "Elephant", isCorrect: false),
        Option(text: "Blue Whale", isCorrect: true),
        Option(text: "Giraffe", isCorrect: false),
        Option(text: "Polar Bear", isCorrect: false),
      ],
      explanation: "The blue whale is the largest animal known to have ever existed.",
    ),
  ];

  void selectOption(int index) {
    if (showAnswer || quizCompleted) return;

    setState(() {
      selectedOptionIndex = index;
      showAnswer = true;

      if (questions[currentQuestionIndex].options[index].isCorrect) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        showAnswer = false;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
      Navigator.pushNamed(
        context,
        '/result',
        arguments: {'score': score, 'totalQuestions': questions.length},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1}/${questions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return OptionWidget(
                option: option,
                onTap: () => selectOption(index),
                isSelected: selectedOptionIndex == index,
                showAnswer: showAnswer,
              );
            }).toList(),
            if (showAnswer) ...[
              const SizedBox(height: 20),
              Text(
                'Explanation: ${currentQuestion.explanation}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
            const Spacer(),
            if (showAnswer || quizCompleted)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestionIndex < questions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                ),
              ),
          ],
        ),
      ),
    );
  }
}