import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'memory_card.dart';

class GameBoard extends StatelessWidget {
  final List<MemoryCard> cards;
  final Function(int) onCardTap;
  final bool isProcessing;

  const GameBoard({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return MemoryCardWidget(
          card: cards[index],
          onTap: () => onCardTap(index),
          isEnabled: !isProcessing,
        );
      },
    );
  }
}