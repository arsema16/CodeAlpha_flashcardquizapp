import 'package:hive/hive.dart';
import '../../domain/entities/flashcard.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 0)
class FlashcardModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String question;
  
  @HiveField(2)
  String answer;
  
  @HiveField(3)
  final DateTime createdAt;
  
  @HiveField(4)
  DateTime updatedAt;

  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlashcardModel.fromEntity(Flashcard flashcard) {
    return FlashcardModel(
      id: flashcard.id,
      question: flashcard.question,
      answer: flashcard.answer,
      createdAt: flashcard.createdAt,
      updatedAt: flashcard.updatedAt,
    );
  }

  Flashcard toEntity() {
    return Flashcard(
      id: id,
      question: question,
      answer: answer,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}