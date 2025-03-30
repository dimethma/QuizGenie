import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizResultPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  QuizResultPage({required this.correctAnswers, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    double percentage = correctAnswers / totalQuestions;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You got $correctAnswers Marks for this",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF271D15),
                ),
              ),
              SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 8.0,
                percent: correctAnswers / totalQuestions,
                center: Text(
                  "$correctAnswers/$totalQuestions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                progressColor: Color(0xFF874E29),
                backgroundColor: Color(0xFFFFFFFF),
                circularStrokeCap: CircularStrokeCap.round,
              ),

              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 95,
                    width: 130, // Set a fixed height
                    child: Expanded(
                      child: _infoCard("$totalQuestions", "Questions"),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 95,
                    width: 130, // Set a fixed height
                    child: Expanded(
                      child: _infoCard(
                        "$correctAnswers",
                        "Marks",
                        icon: Icons.sentiment_satisfied,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionButton(context, "Retry", Color(0xFF101713), () {
                    Navigator.pop(context);
                  }),
                  SizedBox(width: 20),
                  _actionButton(context, "Done", Color(0xFF101713), () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String value, String label, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF874E29),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 24),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(label, style: TextStyle(color: Colors.white70)),
        ],
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
