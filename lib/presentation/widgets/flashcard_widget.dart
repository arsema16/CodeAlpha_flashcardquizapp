import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard card;
  final bool showAnswer;
  final VoidCallback onShowAnswer;

  const FlashcardWidget({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.onShowAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: showAnswer ? _buildBack(context) : _buildFront(context),
    );
  }

  Widget _buildFront(BuildContext context) {
    return _cardContainer(
      context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.help_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 20),
          const Text('QUESTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                card.question,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onShowAnswer,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Show Answer'),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return _cardContainer(
      context,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lightbulb_outline, size: 48, color: Colors.amber),
          const SizedBox(height: 20),
          const Text('ANSWER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                card.answer,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tap Next to continue',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _cardContainer(BuildContext context, {required Widget child}) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        constraints: const BoxConstraints(minHeight: 400),
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}