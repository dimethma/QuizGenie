import 'package:flutter/material.dart';
import 'package:quizgenie/quiz_generator/quiz3.dart';

class QuizGenieApp extends StatelessWidget {
  const QuizGenieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Genie',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF271D15, <int, Color>{
          50: Color(0xFF271D15),
          100: Color(0xFF271D15),
          200: Color(0xFF271D15),
          300: Color(0xFF271D15),
          400: Color(0xFF271D15),
          500: Color(0xFF271D15),
          600: Color(0xFF271D15),
          700: Color(0xFF271D15),
          800: Color(0xFF271D15),
          900: Color(0xFF271D15),
        }),
      ),
      home: const QuizScreen(
        questions: [],
      ), // We will pass questions dynamically later
    );
  }
}
