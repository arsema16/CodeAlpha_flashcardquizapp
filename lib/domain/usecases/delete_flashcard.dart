import '../repositories/flashcard_repository_interface.dart';

class DeleteFlashcard {
  final FlashcardRepositoryInterface repository;

  DeleteFlashcard(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteFlashcard(id);
  }
}