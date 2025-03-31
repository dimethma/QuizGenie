import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizgenie/PaperAnalyzer.dart';
import 'package:quizgenie/QuizG_1.dart';
import 'package:quizgenie/interface/analyzer.dart';
import 'package:quizgenie/interface/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: PaperAnalyzer(),
=======
      home: PaperAnalyzerApp(),
>>>>>>> 0ba7fecb99ad824eac3b1015b907c59cf33cd89a
    );
  }
}
