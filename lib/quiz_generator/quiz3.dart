import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

// Define the Question class
class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  final List<Question>
  questions; // Accepting questions as a constructor parameter

  const QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Timer _timer;
  int _remainingSeconds = 3600;

  int currentQuestionIndex = 0;
  int score = 0;
  int selectedOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        // Show auto submit or message here if time ends
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('⏰ Time is up!')));
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void moveToNextQuestion() {
    if (selectedOptionIndex ==
        widget.questions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }
    setState(() {
      selectedOptionIndex = -1;
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz - ${currentQuestionIndex + 1}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Time Left: ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            Text(question.questionText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedOptionIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOptionIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Text(
                    question.options[index],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (currentQuestionIndex < widget.questions.length - 1) {
                  moveToNextQuestion();
                } else {
                  // Go to result screen when it's the last question
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ResultScreen(
                            score: score,
                            total: widget.questions.length,
                          ),
                    ),
                  );
                }
              },
              child: Text(
                currentQuestionIndex == widget.questions.length - 1
                    ? 'Finish'
                    : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎉 You scored:', style: TextStyle(fontSize: 24)),
            Text(
              '$score / $total',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
