import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/rounded_button.dart';
import '../data/dummy_data.dart';

class StudyScreen extends StatefulWidget {
  final Deck deck;

  const StudyScreen({super.key, required this.deck});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int currentCardIndex = 0;
  bool isFlipped = false;
  late List<Flashcard> deckFlashcards;

  @override
  void initState() {
    super.initState();
    deckFlashcards = dummyFlashcards
        .where((card) => card.deckId == widget.deck.id)
        .toList();
  }

  void nextCard() {
    setState(() {
      if (currentCardIndex < deckFlashcards.length - 1) {
        currentCardIndex++;
        isFlipped = false;
      }
    });
  }

  void previousCard() {
    setState(() {
      if (currentCardIndex > 0) {
        currentCardIndex--;
        isFlipped = false;
      }
    });
  }

  void markAsMemorized() {
    setState(() {
      deckFlashcards[currentCardIndex].isMemorized =
          !deckFlashcards[currentCardIndex].isMemorized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCards = deckFlashcards.isNotEmpty;
    
    if (!hasCards) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Studying: ${widget.deck.title}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_objects_outlined,
                  size: 80,
                  color: widget.deck.color,
                ),
                const SizedBox(height: 30),
                Text(
                  'No Cards to Study',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'This deck doesn\'t have any flashcards yet. Add some cards first!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                RoundedButton(
                  text: 'Go Back',
                  onPressed: () => Navigator.pop(context),
                  fullWidth: true,
                  backgroundColor: widget.deck.color,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentCard = deckFlashcards[currentCardIndex];
    final progress = (currentCardIndex + 1) / deckFlashcards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Studying: ${widget.deck.title}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: widget.deck.color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentCardIndex + 1} of ${deckFlashcards.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% Complete',
                  style: TextStyle(
                    color: widget.deck.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Flashcard
            FlashcardWidget(
              flashcard: currentCard,
              onFlip: () {
                setState(() {
                  isFlipped = !isFlipped;
                });
              },
              isFlipped: isFlipped,
            ),
            const SizedBox(height: 40),

            // Memorized Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: markAsMemorized,
                  icon: Icon(
                    currentCard.isMemorized
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: currentCard.isMemorized ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  currentCard.isMemorized
                      ? 'Memorized ✓'
                      : 'Mark as Memorized',
                  style: TextStyle(
                    color: currentCard.isMemorized ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(
                  text: 'Previous',
                  onPressed: previousCard,
                  backgroundColor: Colors.grey[200]!,
                  textColor: Colors.black,
                ),
                RoundedButton(
                  text: isFlipped ? 'Next Card' : 'Show Answer',
                  onPressed: () {
                    if (isFlipped) {
                      nextCard();
                    } else {
                      setState(() {
                        isFlipped = true;
                      });
                    }
                  },
                  backgroundColor: widget.deck.color,
                ),
              ],
            ),

            const Spacer(),

            // Additional Options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // Shuffle functionality
                    setState(() {
                      deckFlashcards.shuffle();
                      currentCardIndex = 0;
                      isFlipped = false;
                    });
                  },
                  icon: const Icon(Icons.shuffle, size: 28),
                  color: Colors.grey[600],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, size: 28),
                  color: Colors.grey[600],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFlipped = false;
                      currentCardIndex = 0;
                    });
                  },
                  icon: const Icon(Icons.restart_alt, size: 28),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}