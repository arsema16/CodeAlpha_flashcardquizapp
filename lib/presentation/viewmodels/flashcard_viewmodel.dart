import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardViewModel extends ChangeNotifier {
  final List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  List<Flashcard> get flashcards => _flashcards;
  int get currentIndex => _currentIndex;
  bool get showAnswer => _showAnswer;
  Flashcard? get currentCard => 
      _flashcards.isNotEmpty ? _flashcards[_currentIndex] : null;

  void setFlashcards(List<Flashcard> cards) {
    _flashcards.clear();
    _flashcards.addAll(cards);
    _currentIndex = _flashcards.isNotEmpty ? _currentIndex.clamp(0, _flashcards.length - 1) : 0;
    _showAnswer = false;
    notifyListeners();
  }

  void nextCard() {
    if (_flashcards.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _flashcards.length;
    _showAnswer = false;
    notifyListeners();
  }

  void previousCard() {
    if (_flashcards.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _flashcards.length) % _flashcards.length;
    _showAnswer = false;
    notifyListeners();
  }

  void toggleAnswer() {
    _showAnswer = !_showAnswer;
    notifyListeners();
  }

  void setShowAnswer(bool value) {
    _showAnswer = value;
    notifyListeners();
  }

  void addFlashcard(Flashcard card) {
    _flashcards.add(card);
    if (_flashcards.length == 1) _currentIndex = 0;
    notifyListeners();
  }

  void updateFlashcard(int index, Flashcard card) {
    if (index >= 0 && index < _flashcards.length) {
      _flashcards[index] = card;
      notifyListeners();
    }
  }

  void deleteFlashcard(int index) {
    if (index >= 0 && index < _flashcards.length) {
      _flashcards.removeAt(index);
      if (_flashcards.isEmpty) {
        _currentIndex = 0;
      } else if (_currentIndex >= _flashcards.length) {
        _currentIndex = _flashcards.length - 1;
      }
      _showAnswer = false;
      notifyListeners();
    }
  }
}