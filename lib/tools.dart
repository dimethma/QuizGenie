import 'package:flutter/material.dart';
// Import the screen files

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const CategoryScreen(),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Title
              const Padding(
                padding: EdgeInsets.only(left: 4.0, top: 8.0, bottom: 16.0),
                child: Text(
                  'QuizGenie',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tools Section with Brain Lightbulb
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.cyan.shade100],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Text(
                      'Tools',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Brain with lightbulb icon and decorations
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 50),
                        Positioned(
                          right: 12,
                          child: Icon(
                            Icons.psychology,
                            color: Colors.blue.shade800,
                            size: 32,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.stars,
                            color: Colors.purple,
                            size: 16,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 4,
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.blue.shade300,
                            size: 16,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Icon(
                            Icons.menu_book,
                            color: Colors.orange.shade300,
                            size: 18,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Icon(
                            Icons.search,
                            color: Colors.purple.shade200,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Choose Category Text
              const Center(
                child: Text(
                  'Choose Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category Grid - 2x2
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // CHAT Button
                    CategoryButton(
                      title: 'CHAT',
                      icon: Icons.people_outline,
                      color: const Color(0xFFFBD38D),
                      textColor: Colors.white,
                      onTap: () {
                        // Navigate to Chat screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                    ),

                    // Question Generator Button
                    CategoryButton(
                      title: 'Question\nGenerator',
                      icon: Icons.question_mark,
                      color: Colors.cyan.shade50,
                      textColor: Colors.cyan.shade600,
                      onTap: () {
                        // Navigate to Question Generator screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const QuestionGeneratorScreen(),
                          ),
                        );
                      },
                    ),

                    // Quiz Button
                    CategoryButton(
                      title: 'Quiz',
                      icon: Icons.description,
                      color: Colors.cyan.shade50,
                      textColor: Colors.cyan.shade600,
                      onTap: () {
                        // Navigate to Quiz screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizScreen(),
                          ),
                        );
                      },
                    ),

                    // Paper Analyzer Button
                    CategoryButton(
                      title: 'Paper\nAnalyzer',
                      icon: Icons.menu_book_outlined,
                      color: Colors.cyan.shade50,
                      textColor: Colors.cyan.shade600,
                      onTap: () {
                        // Navigate to Paper Analyzer screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaperAnalyzerScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Navigation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavBarItem(
                    icon: Icons.home,
                    isSelected: true,
                    onTap: () {
                      // Already on home screen
                    },
                  ),
                  NavBarItem(
                    icon: Icons.search,
                    isSelected: false,
                    onTap: () {
                      // Navigate to Search screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                  NavBarItem(
                    icon: Icons.person,
                    isSelected: false,
                    onTap: () {
                      // Navigate to Profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const CategoryButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFD4AF37) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

// Placeholder screen classes that would be in separate files
// These would normally be in their own dart files in the screens directory

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color(0xFFFBD38D),
      ),
      body: const Center(child: Text('Chat Screen')),
    );
  }
}

class QuestionGeneratorScreen extends StatelessWidget {
  const QuestionGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Generator'),
        backgroundColor: Colors.cyan,
      ),
      body: const Center(child: Text('Question Generator Screen')),
    );
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz'), backgroundColor: Colors.cyan),
      body: const Center(child: Text('Quiz Screen')),
    );
  }
}

class PaperAnalyzerScreen extends StatelessWidget {
  const PaperAnalyzerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paper Analyzer'),
        backgroundColor: Colors.cyan,
      ),
      body: const Center(child: Text('Paper Analyzer Screen')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}
