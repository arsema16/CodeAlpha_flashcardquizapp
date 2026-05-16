import '../../domain/entities/flashcard.dart';

abstract class FlashcardRepositoryInterface {
  Future<List<Flashcard>> getAllFlashcards();
  Future<void> addFlashcard(Flashcard flashcard);
  Future<void> updateFlashcard(Flashcard flashcard);
  Future<void> deleteFlashcard(String id);
}