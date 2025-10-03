import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';  // Add this import

class OptionWidget extends StatelessWidget {
  final Option option;
  final VoidCallback onTap;
  final bool isSelected;
  final bool showAnswer;

  const OptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    this.isSelected = false,
    this.showAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey;

    if (isSelected) {
      backgroundColor = Colors.blue.withOpacity(0.1);
      borderColor = Colors.blue;
    }

    if (showAnswer) {
      if (option.isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.2);
        borderColor = Colors.green;
      } else if (isSelected && !option.isCorrect) {
        backgroundColor = Colors.red.withOpacity(0.2);
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(child: Text(option.text)),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: showAnswer && !option.isCorrect ? Colors.red : Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}