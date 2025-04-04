import 'package:flutter/material.dart';
import 'interface/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizGenie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        fontFamily: 'Poppins',
      ),
      home: const QuizGenieIntroScreen(),
    );
  }
}

class QuizGenieIntroScreen extends StatefulWidget {
  const QuizGenieIntroScreen({super.key});

  @override
  _QuizGenieIntroScreenState createState() => _QuizGenieIntroScreenState();
}

class _QuizGenieIntroScreenState extends State<QuizGenieIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.3),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            navigateToLogin();
          }
        },
        onTap: () {
          navigateToLogin();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.black,
                Color(0xFFB8860B).withOpacity(0.5),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 70),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Q",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          TextSpan(
                            text: "uiz",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "G",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          TextSpan(
                            text: "enie",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Transform.rotate(
                      angle: 0.1,
                      child: Icon(
                        Icons.menu_book,
                        color: Color(0xFFD4AF37),
                        size: 24,
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      "? \n? ? \n? ?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD4AF37),
                        height: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Find & Create all your tests\nat your fingertips",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "With our newest AI search & find technology",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                Spacer(),

                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.grey.shade300,
                        size: 32,
                      ),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.grey.shade300,
                        size: 32,
                      ),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.grey.shade300,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  "Swipe up to continue",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
