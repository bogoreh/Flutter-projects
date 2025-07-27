import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage >= 70
                          ? Colors.green
                          : percentage >= 40
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              '$score out of $totalQuestions correct',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              _getResultMessage(percentage),
              style: TextStyle(
                fontSize: 18,
                color: percentage >= 70
                    ? Colors.green
                    : percentage >= 40
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/quiz');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  String _getResultMessage(int percentage) {
    if (percentage >= 90) {
      return 'Excellent! You know your stuff!';
    } else if (percentage >= 70) {
      return 'Good job! You did well.';
    } else if (percentage >= 40) {
      return 'Not bad! Keep learning.';
    } else {
      return 'Keep practicing! You can do better.';
    }
  }
}