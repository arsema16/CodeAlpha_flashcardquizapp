import 'package:hive_flutter/hive_flutter.dart';
import '../data/datasources/local_datasource.dart';
import '../data/repositories/flashcard_repository.dart';
import '../data/models/flashcard_model.dart';
import '../domain/repositories/flashcard_repository_interface.dart';
import '../domain/usecases/get_all_flashcards.dart';
import '../domain/usecases/add_flashcard.dart';
import '../domain/usecases/update_flashcard.dart';
import '../domain/usecases/delete_flashcard.dart';

// Service locator instance
final serviceLocator = ServiceLocator();

// Helper function to get dependencies
T getIt<T>(T Function(ServiceLocator) resolver) {
  return resolver(serviceLocator);
}

class ServiceLocator {
  late final LocalDataSource localDataSource;
  late final FlashcardRepositoryInterface flashcardRepository;
  late final GetAllFlashcards getAllFlashcards;
  late final AddFlashcard addFlashcard;
  late final UpdateFlashcard updateFlashcard;
  late final DeleteFlashcard deleteFlashcard;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Hive adapter manually
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FlashcardModelAdapter());
    }
    
    // Initialize local data source
    localDataSource = LocalDataSource();
    await localDataSource.init();
    
    // Initialize repository
    flashcardRepository = FlashcardRepository(localDataSource: localDataSource);
    
    // Initialize use cases
    getAllFlashcards = GetAllFlashcards(flashcardRepository);
    addFlashcard = AddFlashcard(flashcardRepository);
    updateFlashcard = UpdateFlashcard(flashcardRepository);
    deleteFlashcard = DeleteFlashcard(flashcardRepository);
  }
}

// Shortcut getters for common dependencies
GetAllFlashcards get getAllFlashcardsUseCase => serviceLocator.getAllFlashcards;
AddFlashcard get addFlashcardUseCase => serviceLocator.addFlashcard;
UpdateFlashcard get updateFlashcardUseCase => serviceLocator.updateFlashcard;
DeleteFlashcard get deleteFlashcardUseCase => serviceLocator.deleteFlashcard;