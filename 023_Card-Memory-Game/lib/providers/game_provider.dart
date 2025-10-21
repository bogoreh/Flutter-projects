import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameProvider with ChangeNotifier {
  List<MemoryCard> _cards = [];
  List<MemoryCard> _flippedCards = [];
  int _moves = 0;
  int _matches = 0;
  bool _isProcessing = false;

  List<MemoryCard> get cards => _cards;
  int get moves => _moves;
  int get matches => _matches;
  bool get isProcessing => _isProcessing;
  bool get isGameComplete => _matches == 8;

  GameProvider() {
    _initializeGame();
  }

  void _initializeGame() {
    // Using emojis as card content for simplicity
    final List<String> cardImages = [
      '🎮', '🎮', '🎨', '🎨', '🚀', '🚀', '🌟', '🌟',
      '🎵', '🎵', '🎯', '🎯', '🌈', '🌈', '⚡', '⚡'
    ];
    
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
    notifyListeners();
  }

  void _shuffleCards() {
    _cards.shuffle();
  }

  void flipCard(int index) {
    if (_isProcessing || 
        _cards[index].isFlipped || 
        _cards[index].isMatched || 
        _flippedCards.length == 2) {
      return;
    }

    _cards[index] = _cards[index].copyWith(isFlipped: true);
    _flippedCards.add(_cards[index]);
    notifyListeners();

    if (_flippedCards.length == 2) {
      _moves++;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    _isProcessing = true;
    
    if (_flippedCards[0].imagePath == _flippedCards[1].imagePath) {
      // Match found
      _matches++;
      for (int i = 0; i < _cards.length; i++) {
        if (_cards[i].isFlipped && !_cards[i].isMatched) {
          _cards[i] = _cards[i].copyWith(isMatched: true);
        }
      }
      _flippedCards.clear();
      _isProcessing = false;
      notifyListeners();
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        for (int i = 0; i < _cards.length; i++) {
          if (_cards[i].isFlipped && !_cards[i].isMatched) {
            _cards[i] = _cards[i].copyWith(isFlipped: false);
          }
        }
        _flippedCards.clear();
        _isProcessing = false;
        notifyListeners();
      });
    }
  }

  void resetGame() {
    _initializeGame();
  }
}