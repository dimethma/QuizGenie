import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizgenie/Home.dart';
import 'package:quizgenie/QuizG_1.dart';
import 'package:quizgenie/QuizG_3.dart';
import 'package:quizgenie/chat.dart';
import 'package:quizgenie/interface/account.dart';
import 'package:quizgenie/interface/login.dart';
import 'package:quizgenie/interface/ResetPassword.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizResultPage(
        correctAnswers: 35, // Example value (replace with actual variable)
        totalQuestions: 50, // Example value (replace with actual variable)
      ),
    );
=======
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
>>>>>>> b18d7e92988712ecd360632b2f42e46934dc354a
  }
}
