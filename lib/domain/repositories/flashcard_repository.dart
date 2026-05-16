import '../../data/datasources/local_datasource.dart';
import '../../data/models/flashcard_model.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository_interface.dart';

class FlashcardRepository implements FlashcardRepositoryInterface {
  final LocalDataSource localDataSource;

  FlashcardRepository({required this.localDataSource});

  @override
  Future<List<Flashcard>> getAllFlashcards() async {
    try {
      final models = localDataSource.getAllFlashcards();
      final flashcards = models.map((model) => model.toEntity()).toList();
      return flashcards;
    } catch (e) {
      throw Exception('Failed to load flashcards: $e');
    }
  }

  @override
  Future<void> addFlashcard(Flashcard flashcard) async {
    try {
      final model = FlashcardModel.fromEntity(flashcard);
      await localDataSource.addFlashcard(model);
    } catch (e) {
      throw Exception('Failed to add flashcard: $e');
    }
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async {
    try {
      final model = FlashcardModel.fromEntity(flashcard);
      await localDataSource.updateFlashcard(model);
    } catch (e) {
      throw Exception('Failed to update flashcard: $e');
    }
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    try {
      await localDataSource.deleteFlashcard(id);
    } catch (e) {
      throw Exception('Failed to delete flashcard: $e');
    }
  }
}