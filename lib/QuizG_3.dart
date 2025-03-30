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
      backgroundColor: Color(0xFF271D15), // Background color behind the card
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(05), // Space around the card
            decoration: BoxDecoration(
              color: Color(0xFF271D15), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
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
                      "You got $correctAnswers Marks for this",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF271D15),
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
                      progressColor: Color(0xFF874E29),
                      backgroundColor: Color.fromARGB(127, 244, 214, 130),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    SizedBox(height: 5),
                    SizedBox(height: 5),
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
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _actionButton(context, "Retry", Color(0xFF874E29), () {
                          Navigator.pop(context);
                        }),
                        SizedBox(width: 20),
                        _actionButton(context, "Done", Color(0xFF874E29), () {
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
      color: Color(0xFFF4D582),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: Color(0xFF874E29), size: 24),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF874E29),
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Color.fromARGB(226, 135, 79, 41)),
            ),
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
