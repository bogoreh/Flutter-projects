import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../widgets/rounded_button.dart';
import '../data/dummy_data.dart';
import 'study_screen.dart';

class DeckScreen extends StatelessWidget {
  final Deck deck;

  const DeckScreen({super.key, required this.deck});

  List<Flashcard> getDeckFlashcards() {
    return dummyFlashcards
        .where((card) => card.deckId == deck.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = getDeckFlashcards();
    final hasCards = flashcards.isNotEmpty;
    final memorizedCount =
        flashcards.where((card) => card.isMemorized).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deck Header
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: deck.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: deck.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        deck.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deck.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          deck.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${flashcards.length} cards available',
                          style: TextStyle(
                            fontSize: 14,
                            color: deck.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            if (hasCards) ...[
              // Progress Section (only show if there are cards)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '$memorizedCount/${flashcards.length}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Memorized',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${deck.cardCount}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Cards',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        flashcards.isEmpty
                            ? '0%'
                            : '${(memorizedCount / flashcards.length * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Action Buttons
              RoundedButton(
                text: 'Start Studying',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudyScreen(deck: deck),
                    ),
                  );
                },
                fullWidth: true,
                backgroundColor: deck.color,
              ),
              const SizedBox(height: 15),
              RoundedButton(
                text: 'Shuffle Cards',
                onPressed: () {},
                fullWidth: true,
                backgroundColor: Colors.white,
                textColor: deck.color,
              ),
              const SizedBox(height: 30),

              // Flashcards List
              const Text(
                'Cards in this deck',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    final card = flashcards[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: card.isMemorized
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                          child: Icon(
                            card.isMemorized
                                ? Icons.check_circle
                                : Icons.circle,
                            color: card.isMemorized ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text(
                          card.question,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Tap to view answer',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: card.isMemorized
                                ? Colors.red
                                : Colors.grey[300],
                          ),
                          onPressed: () {},
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Flashcard'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Q: ${card.question}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'A: ${card.answer}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              // Empty State
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: deck.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 60,
                          color: deck.color,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'No Flashcards Yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Add some flashcards to start studying this deck',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 30),
                      RoundedButton(
                        text: 'Add First Card',
                        onPressed: () {
                          // TODO: Implement add card functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add card functionality coming soon!'),
                            ),
                          );
                        },
                        backgroundColor: deck.color,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}