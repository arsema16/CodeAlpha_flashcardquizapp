import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'di/injection_container.dart';
import 'presentation/providers/flashcard_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await serviceLocator.init();
  
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FlashcardProvider(
            getAllFlashcards: serviceLocator.getAllFlashcards,
            addFlashcard: serviceLocator.addFlashcard,
            updateFlashcard: serviceLocator.updateFlashcard,
            deleteFlashcard: serviceLocator.deleteFlashcard,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flashcard Studio',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}