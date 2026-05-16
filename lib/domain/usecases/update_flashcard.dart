import '../entities/flashcard.dart';
import '../repositories/flashcard_repository_interface.dart';

class UpdateFlashcard {
  final FlashcardRepositoryInterface repository;

  UpdateFlashcard(this.repository);

  Future<void> call(Flashcard flashcard) async {
    return await repository.updateFlashcard(flashcard);
  }
}