import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizgenie/Home.dart';
import 'package:quizgenie/chat.dart';
import 'package:quizgenie/interface/login.dart';
import 'package:quizgenie/interface/paper_analyxer/PaperAnalyzer.dart';
import 'package:quizgenie/quiz_generator/quiz.dart';
import 'package:quizgenie/startup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizGenie',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
<<<<<<< HEAD
      home: QuizGenieIntroScreen(),
=======
      home: TopicBreakdownAnalyzer(),
>>>>>>> d075a566186ad24022ad198a9b17b5174b9c5adc
    );
  }
}
