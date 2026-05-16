import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/flashcard_form.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/empty_state.dart';
import '../../domain/entities/flashcard.dart';
import 'quiz_screen.dart'; // Add this when you create quiz_screen.dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('📇 Flashcard Studio'),
        actions: [
          // Quiz Mode Button
          Consumer<FlashcardProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.quiz),
                onPressed: provider.viewModel.flashcards.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              flashcards: provider.viewModel.flashcards,
                            ),
                          ),
                        );
                      }
                    : null,
                tooltip: 'Take a Quiz',
              );
            },
          ),
          // Add Card Button
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showFlashcardForm(context),
            tooltip: 'Add Flashcard',
          ),
        ],
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.viewModel.flashcards.isEmpty) {
            return EmptyState(
              onAddPressed: () => _showFlashcardForm(context),
            );
          }
          
          return Column(
            children: [
              _buildProgressIndicator(context, provider),
              Expanded(
                child: FlashcardWidget(
                  card: provider.viewModel.currentCard!,
                  showAnswer: provider.viewModel.showAnswer,
                  onShowAnswer: provider.toggleAnswer,
                ),
              ),
              NavigationButtons(
                onPrevious: provider.previousCard,
                onNext: provider.nextCard,
                onEdit: () => _showFlashcardForm(context,
                    card: provider.viewModel.currentCard,
                    index: provider.viewModel.currentIndex),
                onDelete: () => _confirmDelete(context, provider),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, FlashcardProvider provider) {
    final total = provider.viewModel.flashcards.length;
    final current = provider.viewModel.currentIndex + 1;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Card $current of $total',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$total total',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showFlashcardForm(BuildContext context, {Flashcard? card, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => FlashcardForm(
        card: card,
        onSubmit: (question, answer) async {
          final provider = context.read<FlashcardProvider>();
          bool success;
          
          if (card == null) {
            final newCard = Flashcard(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              question: question,
              answer: answer,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            success = await provider.addNewFlashcard(newCard);
          } else {
            final updatedCard = card.copyWith(
              question: question,
              answer: answer,
              updatedAt: DateTime.now(),
            );
            success = await provider.updateExistingFlashcard(index!, updatedCard);
          }
          
          if (success && context.mounted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(card == null ? 'Card added!' : 'Card updated!'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, FlashcardProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: Text('Delete "${provider.viewModel.currentCard?.question}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final success = await provider.deleteExistingFlashcard(
                provider.viewModel.currentCard!.id,
                provider.viewModel.currentIndex,
              );
              if (success && context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card deleted')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}