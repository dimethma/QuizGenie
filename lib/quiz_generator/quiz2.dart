import 'package:flutter/material.dart';
import 'package:quizgenie/quiz_generator/quiz3.dart';

List<Question> sampleQuestions = [
  Question(
    questionText: 'What does HTTP stand for?',
    options: [
      'HyperText Transition Protocol',
      'HyperText Transmission Protocol',
      'Hyper Transfer Text Protocol',
      'HyperText Transfer Protocol',
    ],
    correctAnswerIndex: 3,
  ),
  Question(
    questionText: 'What is Flutter used for?',
    options: [
      'Web Development',
      'Mobile App Development',
      'Data Analysis',
      'Machine Learning',
    ],
    correctAnswerIndex: 1,
  ),
];

class AddPapersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Papers")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to QuizScreen and pass the list of questions
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(questions: sampleQuestions),
              ),
            );
          },
          child: Text("Start Quiz"),
        ),
      ),
    );
  }
}
