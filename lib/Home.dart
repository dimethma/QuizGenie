import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizGenie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(
          29,
          23,
          19,
          1,
        ), // Dark background
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(29, 23, 19, 1), // Match background
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          color: const Color.fromRGBO(
            40,
            34,
            30,
            1,
          ), // Slightly lighter than background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizGenie'), centerTitle: true),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 1.0,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          _buildFeatureCard(
            context,
            icon: Icons.home,
            title: 'Home',
            color: Colors.blue[300]!,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.auto_awesome,
            title: 'QuizGenie',
            color: Colors.purple[300]!,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.build,
            title: 'Tools',
            color: Colors.orange[300]!,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.chat,
            title: 'Chat',
            color: Colors.green[300]!,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.question_answer,
            title: 'Question Generator',
            color: Colors.red[300]!,
          ),
          _buildFeatureCard(
            context,
            icon: Icons.quiz,
            title: 'Quiz',
            color: Colors.teal[300]!,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navigating to $title')));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: color),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
