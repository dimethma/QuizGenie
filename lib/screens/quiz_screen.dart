import 'dart:async'; 
import 'package:flutter/material.dart';
import '../models/question.dart';

class AppColors {
  static const Color cream = Color(0xFFF4D582); 
  static const Color darkBrown = Color(0xFF271D15); 
  static const Color black = Color(0xFF101713);
  static const Color brown = Color(0xFF874E29); 
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF0000); 
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int selectedOptionIndex = -1;
  Duration totalTime = const Duration(hours: 1);
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (totalTime.inSeconds > 0) {
          totalTime -= const Duration(seconds: 1);
        } else {
          timer.cancel();
          showTimeUpDialog();
        }
      });
    });
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkBrown,
        title: const Text("Time's Up", style: TextStyle(color: AppColors.cream)),
        content: const Text("The quiz time has expired.", style: TextStyle(color: AppColors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: AppColors.cream)),
          ),
        ],
      ),
    );
  }

  void moveToNextQuestion() {
    if (selectedOptionIndex == sampleQuestions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }
    setState(() {
      selectedOptionIndex = -1;
      if (currentQuestionIndex < sampleQuestions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void moveToPreviousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        selectedOptionIndex = -1;
      }
    });
  }

  void selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  void endQuiz() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkBrown,
        title: const Text("End Quiz", style: TextStyle(color: AppColors.cream)),
        content: const Text("Are you sure you want to end the quiz?", style: TextStyle(color: AppColors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: AppColors.cream)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.brown),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SummaryScreen(score: score, total: sampleQuestions.length),
                ),
              );
            },
            child: const Text("End", style: TextStyle(color: AppColors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = sampleQuestions[currentQuestionIndex];
    final timeStr = totalTime.toString().split('.')[0].padLeft(8, "0").split(":");

    return Scaffold(
      backgroundColor: AppColors.darkBrown,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.access_time, color: AppColors.cream),
                    SizedBox(width: 8),
                    Text("You have", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.cream)),
                  ],
                ),
                ElevatedButton(
                  onPressed: endQuiz,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                  child: const Text("End Quiz", style: TextStyle(color: AppColors.white)),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timeCard(timeStr[0], "Hours"),
                const SizedBox(width: 8),
                timeCard(timeStr[1], "Minutes"),
                const SizedBox(width: 8),
                timeCard(timeStr[2], "Seconds"),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.cream),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedOptionIndex == index;
              return GestureDetector(
                onTap: () => selectOption(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brown : AppColors.darkBrown,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.brown),
                  ),
                  child: Text(
                    question.options[index],
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.cream,
                  onPressed: moveToPreviousQuestion,
                ),
                ...List.generate(sampleQuestions.length, (index) {
                  if ((index - currentQuestionIndex).abs() <= 1) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: index == currentQuestionIndex ? AppColors.cream : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == currentQuestionIndex ? AppColors.darkBrown : AppColors.cream,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: AppColors.cream,
                  onPressed: moveToNextQuestion,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget timeCard(String time, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.brown),
          ),
          child: Text(
            time,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.white)),
      ],
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final int score;
  final int total;

  const SummaryScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBrown,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Quiz Finished", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.cream)),
            const SizedBox(height: 20),
            Text("Score: $score / $total", style: const TextStyle(fontSize: 20, color: AppColors.white)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.brown),
              onPressed: () => Navigator.pop(context),
              child: const Text("Restart Quiz", style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}