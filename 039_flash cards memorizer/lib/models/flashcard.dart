import 'package:flutter/material.dart';

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String deckId;
  bool isMemorized;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.deckId,
    this.isMemorized = false,
  });
}

class Deck {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final int cardCount;

  Deck({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.cardCount,
  });
}