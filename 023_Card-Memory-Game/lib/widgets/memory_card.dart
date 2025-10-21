import 'package:flutter/material.dart';
import '../models/card_model.dart';

class MemoryCardWidget extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final bool isEnabled;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched
              ? _getCardColor(context)
              : Colors.blueGrey[800],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: card.isMatched 
                ? Colors.green 
                : Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: card.isFlipped || card.isMatched ? 1.0 : 0.0,
            child: Text(
              card.imagePath,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(BuildContext context) {
    if (card.isMatched) {
      return Colors.green.withOpacity(0.8);
    }
    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
  }
}