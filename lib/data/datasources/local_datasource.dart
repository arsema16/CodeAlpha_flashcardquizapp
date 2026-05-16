import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard_model.dart';
import '../../core/constants/app_constants.dart';

class LocalDataSource {
  late Box<FlashcardModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<FlashcardModel>(AppConstants.flashcardsBoxName);
  }

  List<FlashcardModel> getAllFlashcards() {
    return _box.values.toList();
  }

  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await _box.put(flashcard.id, flashcard);
  }

  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    flashcard.updatedAt = DateTime.now();
    await _box.put(flashcard.id, flashcard);
  }

  Future<void> deleteFlashcard(String id) async {
    await _box.delete(id);
  }
}