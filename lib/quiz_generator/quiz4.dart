import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizResultPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const QuizResultPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = correctAnswers / totalQuestions;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color.fromARGB(200, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You got $correctAnswers out of $totalQuestions correct!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 80),
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 8.0,
                      percent: percentage,
                      center: Text(
                        "$correctAnswers/$totalQuestions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      progressColor: Colors.orange,
                      backgroundColor: Colors.grey[300]!,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    SizedBox(height: 5),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 95,
                          width: 130,
                          child: _infoCard("$totalQuestions", "Questions"),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 95,
                          width: 130,
                          child: _infoCard(
                            "$correctAnswers",
                            "Marks",
                            icon: Icons.sentiment_satisfied,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _actionButton(context, "Retry", Colors.orange, () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                        SizedBox(width: 20),
                        _actionButton(context, "Done", Colors.orange, () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String value, String label, {IconData? icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.orange,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: Colors.black, size: 24),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
