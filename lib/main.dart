import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizgenie/Home.dart';
import 'package:quizgenie/QuizG_1.dart';
import 'package:quizgenie/chat.dart';
import 'package:quizgenie/interface/account.dart';
import 'package:quizgenie/interface/login.dart';
import 'package:quizgenie/interface/ResetPassword.dart';
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
