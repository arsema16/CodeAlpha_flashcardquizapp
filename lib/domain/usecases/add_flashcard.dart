import '../entities/flashcard.dart';
import '../repositories/flashcard_repository_interface.dart';

class AddFlashcard {
  final FlashcardRepositoryInterface repository;

  AddFlashcard(this.repository);

  Future<void> call(Flashcard flashcard) async {
    return await repository.addFlashcard(flashcard);
  }
}