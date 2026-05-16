import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';

class QuizScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  
  const QuizScreen({super.key, required this.flashcards});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;
  bool showResult = false;
  String? selectedAnswer;
  
  List<String> get options {
    final currentCard = widget.flashcards[currentIndex];
    final options = <String>[currentCard.answer];
    
    // Add random wrong answers from other flashcards
    for (var card in widget.flashcards) {
      if (card.answer != currentCard.answer && options.length < 4) {
        options.add(card.answer);
      }
    }
    
    // If not enough options, add placeholder options
    while (options.length < 4) {
      options.add('Option ${options.length + 1}');
    }
    
    options.shuffle();
    return options;
  }
  
  void checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      if (answer == widget.flashcards[currentIndex].answer) {
        score++;
      }
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex + 1 < widget.flashcards.length) {
        setState(() {
          currentIndex++;
          selectedAnswer = null;
        });
      } else {
        setState(() {
          showResult = true;
        });
      }
    });
  }
  
  void restartQuiz() {
    setState(() {
      currentIndex = 0;
      score = 0;
      showResult = false;
      selectedAnswer = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showResult) {
      final percentage = (score / widget.flashcards.length * 100).round();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Complete!'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  percentage >= 70 ? Icons.emoji_events : Icons.school,
                  size: 100,
                  color: percentage >= 70 ? Colors.amber : Colors.blue,
                ),
                const SizedBox(height: 30),
                Text(
                  'Your Score: $score/${widget.flashcards.length}',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 24,
                    color: percentage >= 70 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  percentage >= 70 
                      ? 'Excellent! Keep up the great work! 🎉'
                      : 'Good try! Study more and try again! 💪',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.home),
                        label: const Text('Back to Study'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: restartQuiz,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    final currentCard = widget.flashcards[currentIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${currentIndex + 1}/${widget.flashcards.length}'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.flashcards.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score/${widget.flashcards.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            // Question card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  currentCard.question,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  bool isSelected = selectedAnswer == option;
                  bool isCorrect = option == currentCard.answer;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedAnswer == null ? () => checkAnswer(option) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : null,
                          foregroundColor: isSelected ? Colors.white : null,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}