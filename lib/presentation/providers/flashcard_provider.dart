import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/get_all_flashcards.dart';
import '../../domain/usecases/add_flashcard.dart';
import '../../domain/usecases/update_flashcard.dart';
import '../../domain/usecases/delete_flashcard.dart';
import '../viewmodels/flashcard_viewmodel.dart';

class FlashcardProvider extends ChangeNotifier {
  final GetAllFlashcards getAllFlashcards;
  final AddFlashcard addFlashcard;
  final UpdateFlashcard updateFlashcard;
  final DeleteFlashcard deleteFlashcard;
  
  final FlashcardViewModel _viewModel = FlashcardViewModel();
  
  bool _isLoading = false;
  String? _errorMessage;

  FlashcardProvider({
    required this.getAllFlashcards,
    required this.addFlashcard,
    required this.updateFlashcard,
    required this.deleteFlashcard,
  }) {
    loadFlashcards();
  }

  FlashcardViewModel get viewModel => _viewModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFlashcards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final flashcards = await getAllFlashcards();
      _viewModel.setFlashcards(flashcards);
    } catch (error) {
      _errorMessage = error.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addNewFlashcard(Flashcard flashcard) async {
    try {
      await addFlashcard(flashcard);
      _viewModel.addFlashcard(flashcard);
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExistingFlashcard(int index, Flashcard flashcard) async {
    try {
      await updateFlashcard(flashcard);
      _viewModel.updateFlashcard(index, flashcard);
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExistingFlashcard(String id, int index) async {
    try {
      await deleteFlashcard(id);
      _viewModel.deleteFlashcard(index);
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  void nextCard() => _viewModel.nextCard();
  void previousCard() => _viewModel.previousCard();
  void toggleAnswer() => _viewModel.toggleAnswer();
}