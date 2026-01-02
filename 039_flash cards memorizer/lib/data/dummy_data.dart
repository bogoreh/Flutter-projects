import 'package:flutter/material.dart';
import '../models/flashcard.dart';

List<Deck> dummyDecks = [
  Deck(
    id: '1',
    title: 'Basic Vocabulary',
    description: 'Essential words for beginners',
    icon: '📚',
    color: const Color(0xFF6C5CE7),
    cardCount: 15,
  ),
  Deck(
    id: '2',
    title: 'Medical Terms',
    description: 'Medical terminology flashcards',
    icon: '🏥',
    color: const Color(0xFF00B894),
    cardCount: 20,
  ),
  Deck(
    id: '3',
    title: 'Programming',
    description: 'Coding concepts and terms',
    icon: '💻',
    color: const Color(0xFFFD79A8),
    cardCount: 25,
  ),
  Deck(
    id: '4',
    title: 'History Dates',
    description: 'Important historical events',
    icon: '📅',
    color: const Color(0xFFFDCB6E),
    cardCount: 18,
  ),
  Deck(
    id: '5',
    title: 'Math Formulas',
    description: 'Essential mathematics formulas',
    icon: '🧮',
    color: const Color(0xFF74B9FF),
    cardCount: 12,
  ),
  Deck(
    id: '6',
    title: 'Spanish Phrases',
    description: 'Common Spanish expressions',
    icon: '🇪🇸',
    color: const Color(0xFFA29BFE),
    cardCount: 30,
  ),
];

List<Flashcard> dummyFlashcards = [
  // Programming deck (id: 3)
  Flashcard(
    id: '1',
    question: 'What is Flutter?',
    answer: 'Flutter is an open-source UI software development kit created by Google.',
    deckId: '3',
  ),
  Flashcard(
    id: '2',
    question: 'What is a Widget?',
    answer: 'A widget is a basic building block of Flutter app\'s user interface.',
    deckId: '3',
  ),
  Flashcard(
    id: '3',
    question: 'What is Dart?',
    answer: 'Dart is a client-optimized programming language for fast apps on any platform.',
    deckId: '3',
  ),
  
  // Spanish Phrases deck (id: 6)
  Flashcard(
    id: '4',
    question: 'Hola',
    answer: 'Hello',
    deckId: '6',
  ),
  Flashcard(
    id: '5',
    question: 'Gracias',
    answer: 'Thank you',
    deckId: '6',
  ),
  Flashcard(
    id: '6',
    question: 'Por favor',
    answer: 'Please',
    deckId: '6',
  ),
  
  // Math Formulas deck (id: 5)
  Flashcard(
    id: '7',
    question: 'E = mc²',
    answer: 'Einstein\'s mass-energy equivalence formula',
    deckId: '5',
  ),
  Flashcard(
    id: '8',
    question: 'a² + b² = c²',
    answer: 'Pythagorean theorem for right triangles',
    deckId: '5',
  ),
  
  // Basic Vocabulary deck (id: 1)
  Flashcard(
    id: '9',
    question: 'Abundant',
    answer: 'Existing in large quantities; plentiful',
    deckId: '1',
  ),
  Flashcard(
    id: '10',
    question: 'Benevolent',
    answer: 'Well meaning and kindly',
    deckId: '1',
  ),
  
  // Medical Terms deck (id: 2)
  Flashcard(
    id: '11',
    question: 'Cardiology',
    answer: 'The study of the heart and its diseases',
    deckId: '2',
  ),
  Flashcard(
    id: '12',
    question: 'Neurology',
    answer: 'The study of the nervous system',
    deckId: '2',
  ),
  
  // History Dates deck (id: 4)
  Flashcard(
    id: '13',
    question: '1776',
    answer: 'Year of American Declaration of Independence',
    deckId: '4',
  ),
  Flashcard(
    id: '14',
    question: '1066',
    answer: 'Battle of Hastings, Norman conquest of England',
    deckId: '4',
  ),
];