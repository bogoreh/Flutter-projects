import 'package:flutter/material.dart';
import 'models/card_model.dart';
import 'widgets/game_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Card Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<MemoryCard> _cards = [];
  List<MemoryCard> _flippedCards = [];
  int _moves = 0;
  int _matches = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final List<String> cardImages = [
      '🎮', '🎮', '🎨', '🎨', '🚀', '🚀', '🌟', '🌟',
      '🎵', '🎵', '🎯', '🎯', '🌈', '🌈', '⚡', '⚡'
    ];
    
    setState(() {
      _cards = [];
      for (int i = 0; i < cardImages.length; i++) {
        _cards.add(MemoryCard(
          id: i,
          imagePath: cardImages[i],
        ));
      }
      
      _shuffleCards();
      _moves = 0;
      _matches = 0;
      _flippedCards.clear();
    });
  }

  void _shuffleCards() {
    setState(() {
      _cards.shuffle();
    });
  }

  void _flipCard(int index) {
    if (_isProcessing || 
        _cards[index].isFlipped || 
        _cards[index].isMatched || 
        _flippedCards.length == 2) {
      return;
    }

    setState(() {
      _cards[index] = _cards[index].copyWith(isFlipped: true);
      _flippedCards.add(_cards[index]);
    });

    if (_flippedCards.length == 2) {
      setState(() {
        _moves++;
      });
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    _isProcessing = true;
    
    if (_flippedCards[0].imagePath == _flippedCards[1].imagePath) {
      // Match found
      setState(() {
        _matches++;
        for (int i = 0; i < _cards.length; i++) {
          if (_cards[i].isFlipped && !_cards[i].isMatched) {
            _cards[i] = _cards[i].copyWith(isMatched: true);
          }
        }
        _flippedCards.clear();
        _isProcessing = false;
      });
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          for (int i = 0; i < _cards.length; i++) {
            if (_cards[i].isFlipped && !_cards[i].isMatched) {
              _cards[i] = _cards[i].copyWith(isFlipped: false);
            }
          }
          _flippedCards.clear();
          _isProcessing = false;
        });
      });
    }
  }

  void _resetGame() {
    _initializeGame();
  }

  bool get _isGameComplete => _matches == 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Memory Game'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Restart Game',
          ),
        ],
      ),
      body: Column(
        children: [
          // Game Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Moves',
                  _moves.toString(),
                  Icons.directions_run,
                ),
                _buildStatItem(
                  context,
                  'Matches',
                  '$_matches/8',
                  Icons.star,
                ),
              ],
            ),
          ),

          // Game Board or Completion Screen
          Expanded(
            child: _isGameComplete
                ? _buildGameComplete(context)
                : GameBoard(
                    cards: _cards,
                    onCardTap: _flipCard,
                    isProcessing: _isProcessing,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildGameComplete(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.celebration,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'You completed the game in $_moves moves!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _resetGame,
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}