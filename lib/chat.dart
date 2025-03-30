import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Main app entry point
void main() {
  runApp(FeedScreen());
}

// Enhanced color palette with modern touch
class AppColors {
  static const Color cream = Color(0xFFF4D582);
  static const Color darkBrown = Color(0xFF271D15);
  static const Color black = Color(0xFF101713);
  static const Color brown = Color(0xFF874E29);
  static const Color lightCream = Color(0xFFF8E4A8);
  static const Color mediumBrown = Color(0xFFA97348);
  static const Color offWhite = Color(0xFFF7F5F0);

  // Enhanced complementary colors
  static const Color deepAmber = Color(0xFFD0832C);
  static const Color oliveGreen = Color(0xFF4A5D23);
  static const Color softTeal = Color(0xFF5A7D7C);
  static const Color dustyRose = Color(0xFFCF8B7F);
  static const Color mochaBrown = Color(0xFF6E4238); // New darker brown
  static const Color caramel = Color(0xFFBF8456); // New medium amber
  static const Color sage = Color(0xFF7A8D5A); // New green tone
  static const Color terracotta = Color(0xFFCF6A4E); // New warm accent

  // Updated gradient definitions
  static List<Color> creamToAmberGradient = [cream, deepAmber];
  static List<Color> brownToDarkBrownGradient = [brown, darkBrown];
  static List<Color> tealToOliveGradient = [softTeal, oliveGreen];
  static List<Color> caramelToMochaGradient = [caramel, mochaBrown]; // New
  static List<Color> sageToOliveGradient = [sage, oliveGreen]; // New
  static List<Color> creamToTerracottaGradient = [
    cream.withOpacity(0.8),
    terracotta,
  ]; // New
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Community App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.darkBrown,
        scaffoldBackgroundColor: AppColors.lightCream.withOpacity(0.3),
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBrown,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.cream,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.cream),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkBrown),
          bodyMedium: TextStyle(color: AppColors.darkBrown),
          titleLarge: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brown,
            foregroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: AppColors.brown,
          secondary: AppColors.caramel,
          surface: AppColors.offWhite,
          background: AppColors.lightCream,
          onPrimary: AppColors.cream,
          onSecondary: AppColors.cream,
          onSurface: AppColors.darkBrown,
          onBackground: AppColors.darkBrown,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final String? _currentUserId = '123'; // Simulated logged-in user ID

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      FeedScreen(currentUserId: _currentUserId),
      Center(child: Text('Study Groups (Coming Soon)')),
      Center(child: Text('Resources (Coming Soon)')),
      Center(child: Text('Profile (Coming Soon)')),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.cream.withOpacity(0.1),
              AppColors.lightCream.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBrown.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(color: AppColors.mochaBrown.withOpacity(0.1)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: AppColors.caramel,
          unselectedItemColor: AppColors.mochaBrown.withOpacity(0.7),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient:
                      _currentIndex == 0
                          ? LinearGradient(
                            colors: [
                              AppColors.caramel.withOpacity(0.2),
                              AppColors.mochaBrown.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient:
                      _currentIndex == 1
                          ? LinearGradient(
                            colors: [
                              AppColors.caramel.withOpacity(0.2),
                              AppColors.mochaBrown.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.group),
              ),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient:
                      _currentIndex == 2
                          ? LinearGradient(
                            colors: [
                              AppColors.caramel.withOpacity(0.2),
                              AppColors.mochaBrown.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.book),
              ),
              label: 'Resources',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient:
                      _currentIndex == 3
                          ? LinearGradient(
                            colors: [
                              AppColors.caramel.withOpacity(0.2),
                              AppColors.mochaBrown.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Post model class
class Post {
  final String id;
  final String? userId;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final List<Comment> comments;
  final bool isPoll;
  final List<PollOption>? pollOptions;
  final List<String> likes;
  final String? subject; // Educational subject/category
  final bool isQuestion; // Flag to mark as a question
  final bool isResolved; // Flag to mark if question is resolved
  final List<String> tags; // Tags for categorizing the post

  Post({
    required this.id,
    this.userId,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.comments = const [],
    this.isPoll = false,
    this.pollOptions,
    this.likes = const [],
    this.subject,
    this.isQuestion = false,
    this.isResolved = false,
    this.tags = const [],
  });

  String get username => userId != null ? "User_$userId" : "Anonymous";
}

// Comment model class
class Comment {
  final String id;
  final String? userId;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    this.userId,
    required this.content,
    required this.timestamp,
  });

  String get username => userId != null ? "User_$userId" : "Anonymous";
  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 7) {
      return "${(difference.inDays / 7).floor()}w ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }
}

// Poll option model class
class PollOption {
  final String id;
  final String text;
  final List<String> votes;

  PollOption({required this.id, required this.text, this.votes = const []});

  double getPercentage(int totalVotes) {
    if (totalVotes == 0) return 0;
    return votes.length / totalVotes * 100;
  }
}

// Main feed screen
class FeedScreen extends StatefulWidget {
  final String? currentUserId;

  const FeedScreen({Key? key, this.currentUserId}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _subjects = [
    'All',
    'Math',
    'Science',
    'History',
    'Literature',
    'Computer Science',
  ];
  String _selectedSubject = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Post> _posts = [
    // Sample student Q&A posts
    Post(
      id: '1',
      userId: '123',
      content:
          'Can someone help me understand the difference between integrals and derivatives? I\'m struggling with this concept in calculus.',
      imageUrl: 'https://example.com/calculus_problem.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      comments: [
        Comment(
          id: '101',
          userId: '456',
          content:
              'Derivatives measure the rate of change at a specific point, while integrals find the area under the curve. Think of them as opposites: derivatives break down functions, integrals build them up.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
      subject: 'Math',
      isQuestion: true,
      tags: ['Calculus', 'Homework Help'],
    ),
    Post(
      id: '2',
      userId: null,
      content:
          'What\'s the most challenging concept in Computer Science for you?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isPoll: true,
      pollOptions: [
        PollOption(id: '1', text: 'Data Structures', votes: ['user1', 'user2']),
        PollOption(id: '2', text: 'Algorithms', votes: ['user3']),
        PollOption(
          id: '3',
          text: 'Object-Oriented Programming',
          votes: ['user4', 'user5'],
        ),
        PollOption(id: '4', text: 'System Architecture', votes: ['user6']),
      ],
      subject: 'Computer Science',
      tags: ['Discussion', 'Programming'],
    ),
    Post(
      id: '3',
      userId: '789',
      content:
          'I need help explaining the significance of this diagram from our biology textbook. Can anyone explain how photosynthesis works based on this?',
      imageUrl: 'https://example.com/photosynthesis.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      comments: [
        Comment(
          id: '102',
          userId: '321',
          content:
              'The diagram shows how plants convert light energy into chemical energy. The process starts in the chloroplasts where chlorophyll captures sunlight...',
          timestamp: DateTime.now().subtract(const Duration(hours: 20)),
        ),
      ],
      subject: 'Science',
      isQuestion: true,
      tags: ['Biology', 'Photosynthesis'],
    ),
  ];

  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  File? _imageFile;
  bool _isCreatingPoll = false;
  bool _isQuestion = false;
  String _selectedPostSubject = 'Math';
  List<String> _selectedTags = [];
  List<TextEditingController> _pollOptionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    // Show a dialog to choose camera or gallery
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.caramel.withOpacity(0.95),
                AppColors.cream.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBrown.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.mochaBrown.withOpacity(0.5),
                      AppColors.brown.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Add an Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            _imageFile = File(pickedFile.path);
                          });
                        }
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            _imageFile = File(pickedFile.path);
                          });
                        }
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.description,
                      label: 'Document',
                      onTap: () async {
                        Navigator.pop(context);
                        // This would require a file picker package
                        _showSnackBar("Document upload coming soon!");
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.brown.withOpacity(0.1),
              AppColors.caramel.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mochaBrown.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.mochaBrown.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.caramelToMochaGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mochaBrown.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.cream, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTag() {
    if (_tagController.text.isEmpty) return;
    if (_selectedTags.length >= 5) {
      _showSnackBar("You can only add up to 5 tags");
      return;
    }

    setState(() {
      _selectedTags.add(_tagController.text.trim());
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  void _addPollOption() {
    setState(() {
      _pollOptionControllers.add(TextEditingController());
    });
  }

  void _removePollOption(int index) {
    if (_pollOptionControllers.length > 2) {
      setState(() {
        _pollOptionControllers.removeAt(index);
      });
    }
  }

  void _createPost() {
    if (_postController.text.isEmpty &&
        (_imageFile == null && !_isCreatingPoll))
      return;

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.currentUserId,
      content: _postController.text,
      imageUrl: _imageFile != null ? _imageFile!.path : null,
      timestamp: DateTime.now(),
      isPoll: _isCreatingPoll,
      pollOptions:
          _isCreatingPoll
              ? _pollOptionControllers
                  .where((controller) => controller.text.isNotEmpty)
                  .map(
                    (controller) => PollOption(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      text: controller.text,
                    ),
                  )
                  .toList()
              : null,
      subject: _selectedPostSubject,
      isQuestion: _isQuestion,
      tags: List.from(_selectedTags),
    );

    setState(() {
      _posts.insert(0, newPost);
      _postController.clear();
      _imageFile = null;
      _isCreatingPoll = false;
      _isQuestion = false;
      _selectedTags = [];
      _pollOptionControllers = [
        TextEditingController(),
        TextEditingController(),
      ];

      // Show success message
      _showSnackBar(
        _isQuestion
            ? "Question posted successfully!"
            : "Post shared with the community!",
      );
    });
  }

  void _addComment(String postId) {
    if (_commentController.text.isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.currentUserId,
      content: _commentController.text,
      timestamp: DateTime.now(),
    );

    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final updatedComments = List<Comment>.from(_posts[postIndex].comments);
        updatedComments.add(newComment);

        final updatedPost = Post(
          id: _posts[postIndex].id,
          userId: _posts[postIndex].userId,
          content: _posts[postIndex].content,
          imageUrl: _posts[postIndex].imageUrl,
          timestamp: _posts[postIndex].timestamp,
          comments: updatedComments,
          isPoll: _posts[postIndex].isPoll,
          pollOptions: _posts[postIndex].pollOptions,
          likes: _posts[postIndex].likes,
          subject: _posts[postIndex].subject,
          isQuestion: _posts[postIndex].isQuestion,
          isResolved: _posts[postIndex].isResolved,
          tags: _posts[postIndex].tags,
        );

        _posts[postIndex] = updatedPost;
        _commentController.clear();
      }
    });
  }

  void _voteOnPoll(String postId, String optionId) {
    if (widget.currentUserId == null) {
      _showSnackBar("Please log in to vote on polls");
      return;
    }

    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        if (post.isPoll && post.pollOptions != null) {
          // Remove existing votes from this user
          final updatedOptions =
              post.pollOptions!.map((option) {
                final votes =
                    option.votes
                        .where((id) => id != widget.currentUserId)
                        .toList();
                return PollOption(
                  id: option.id,
                  text: option.text,
                  votes: votes,
                );
              }).toList();

          // Add new vote
          final optionIndex = updatedOptions.indexWhere(
            (option) => option.id == optionId,
          );
          if (optionIndex != -1) {
            final option = updatedOptions[optionIndex];
            final updatedVotes = List<String>.from(option.votes);
            updatedVotes.add(widget.currentUserId!);
            updatedOptions[optionIndex] = PollOption(
              id: option.id,
              text: option.text,
              votes: updatedVotes,
            );
          }

          _posts[postIndex] = Post(
            id: post.id,
            userId: post.userId,
            content: post.content,
            imageUrl: post.imageUrl,
            timestamp: post.timestamp,
            comments: post.comments,
            isPoll: true,
            pollOptions: updatedOptions,
            likes: post.likes,
            subject: post.subject,
            isQuestion: post.isQuestion,
            isResolved: post.isResolved,
            tags: post.tags,
          );
        }
      }
    });
  }

  void _likePost(String postId) {
    if (widget.currentUserId == null) {
      _showSnackBar("Please log in to like posts");
      return;
    }

    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final likes = List<String>.from(post.likes);

        if (likes.contains(widget.currentUserId)) {
          likes.remove(widget.currentUserId);
        } else {
          likes.add(widget.currentUserId!);
        }

        _posts[postIndex] = Post(
          id: post.id,
          userId: post.userId,
          content: post.content,
          imageUrl: post.imageUrl,
          timestamp: post.timestamp,
          comments: post.comments,
          isPoll: post.isPoll,
          pollOptions: post.pollOptions,
          likes: likes,
          subject: post.subject,
          isQuestion: post.isQuestion,
          isResolved: post.isResolved,
          tags: post.tags,
        );
      }
    });
  }

  void _toggleResolvedStatus(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        if (post.isQuestion) {
          final newStatus = !post.isResolved;

          _posts[postIndex] = Post(
            id: post.id,
            userId: post.userId,
            content: post.content,
            imageUrl: post.imageUrl,
            timestamp: post.timestamp,
            comments: post.comments,
            isPoll: post.isPoll,
            pollOptions: post.pollOptions,
            likes: post.likes,
            subject: post.subject,
            isQuestion: true,
            isResolved: newStatus,
            tags: post.tags,
          );

          _showSnackBar(
            newStatus
                ? "Question marked as resolved"
                : "Question marked as unresolved",
          );
        }
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: AppColors.cream)),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.mochaBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.all(16),
        elevation: 4,
        action: SnackBarAction(
          label: 'OK',
          textColor: AppColors.cream,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Widget _buildPostAction({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    final hasLabel = label.isNotEmpty;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            if (hasLabel) ...[
              const SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.1), color.withOpacity(0.15)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.05),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    Color textColor = Colors.white,
    List<Color>? gradient,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration:
          gradient != null
              ? BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              )
              : null,
      child: TextButton.icon(
        icon: Icon(icon, color: gradient != null ? textColor : color, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: gradient != null ? textColor : color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor:
              gradient != null ? Colors.transparent : color.withOpacity(0.1),
          elevation: gradient != null ? 0 : 0,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    int totalVotes = 0;
    if (post.isPoll && post.pollOptions != null) {
      totalVotes = post.pollOptions!.fold(
        0,
        (sum, option) => sum + option.votes.length,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shadowColor: AppColors.brown.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                post.isQuestion
                    ? [
                      AppColors.cream.withOpacity(0.2),
                      AppColors.sage.withOpacity(0.1),
                    ]
                    : post.isPoll
                    ? [
                      AppColors.cream.withOpacity(0.15),
                      AppColors.caramel.withOpacity(0.1),
                    ]
                    : [
                      AppColors.cream.withOpacity(0.1),
                      AppColors.lightCream.withOpacity(0.05),
                    ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      post.isQuestion
                          ? [
                            AppColors.sage.withOpacity(0.3),
                            AppColors.oliveGreen.withOpacity(0.15),
                          ]
                          : post.isPoll
                          ? [
                            AppColors.caramel.withOpacity(0.3),
                            AppColors.deepAmber.withOpacity(0.15),
                          ]
                          : [
                            AppColors.caramel.withOpacity(0.25),
                            AppColors.cream.withOpacity(0.2),
                          ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brown.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                post.isQuestion
                                    ? [AppColors.oliveGreen, AppColors.sage]
                                    : post.isPoll
                                    ? [AppColors.deepAmber, AppColors.caramel]
                                    : [AppColors.mochaBrown, AppColors.brown],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBrown.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            post.isQuestion
                                ? Icons.help_outline
                                : post.isPoll
                                ? Icons.poll
                                : Icons.person,
                            color: AppColors.cream,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors:
                                          post.isQuestion
                                              ? [
                                                AppColors.oliveGreen
                                                    .withOpacity(0.7),
                                                AppColors.sage.withOpacity(0.8),
                                              ]
                                              : post.isPoll
                                              ? [
                                                AppColors.deepAmber.withOpacity(
                                                  0.7,
                                                ),
                                                AppColors.caramel.withOpacity(
                                                  0.8,
                                                ),
                                              ]
                                              : [
                                                AppColors.brown.withOpacity(
                                                  0.7,
                                                ),
                                                AppColors.caramel.withOpacity(
                                                  0.8,
                                                ),
                                              ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.darkBrown.withOpacity(
                                          0.05,
                                        ),
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    post.isQuestion
                                        ? 'Question'
                                        : post.isPoll
                                        ? 'Poll'
                                        : 'Post',
                                    style: TextStyle(
                                      color: AppColors.cream,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (post.subject != null) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.mochaBrown.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.mochaBrown.withOpacity(
                                          0.2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      post.subject!,
                                      style: TextStyle(
                                        color: AppColors.mochaBrown,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                Spacer(),
                                Text(
                                  _getTimeAgo(post.timestamp),
                                  style: TextStyle(
                                    color: AppColors.brown.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (post.tags.isNotEmpty) ...[
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          post.tags.map((tag) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.softTeal.withOpacity(0.2),
                                    AppColors.softTeal.withOpacity(0.3),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.softTeal.withOpacity(0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.darkBrown.withOpacity(
                                      0.03,
                                    ),
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  color: AppColors.softTeal,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Post content
            if (post.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  post.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkBrown,
                    height: 1.4,
                  ),
                ),
              ),

            // Post image
            if (post.imageUrl != null)
              Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 300),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.mochaBrown.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mochaBrown.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.cream.withOpacity(0.3),
                              AppColors.brown.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: AppColors.brown,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: TextStyle(color: AppColors.brown),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Poll options
            if (post.isPoll && post.pollOptions != null)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepAmber.withOpacity(0.05),
                      AppColors.caramel.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.deepAmber.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mochaBrown.withOpacity(0.05),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.poll, color: AppColors.deepAmber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Poll Results',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.deepAmber.withOpacity(0.7),
                                AppColors.caramel.withOpacity(0.9),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mochaBrown.withOpacity(0.1),
                                blurRadius: 2,
                                spreadRadius: 0,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            '$totalVotes ${totalVotes == 1 ? 'vote' : 'votes'}',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ...post.pollOptions!.map((option) {
                      final percentage = option.getPercentage(totalVotes);
                      final hasVoted =
                          widget.currentUserId != null &&
                          option.votes.contains(widget.currentUserId);

                      return GestureDetector(
                        onTap: () => _voteOnPoll(post.id, option.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  hasVoted
                                      ? [
                                        AppColors.deepAmber.withOpacity(0.2),
                                        AppColors.caramel.withOpacity(0.3),
                                      ]
                                      : [
                                        AppColors.cream.withOpacity(0.1),
                                        AppColors.lightCream.withOpacity(0.15),
                                      ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  hasVoted
                                      ? AppColors.deepAmber.withOpacity(0.4)
                                      : AppColors.mochaBrown.withOpacity(0.2),
                              width: hasVoted ? 1.5 : 1,
                            ),
                            boxShadow:
                                hasVoted
                                    ? [
                                      BoxShadow(
                                        color: AppColors.mochaBrown.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (hasVoted)
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.deepAmber,
                                            AppColors.caramel,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.deepAmber
                                                .withOpacity(0.2),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: AppColors.cream,
                                        size: 12,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: TextStyle(
                                        color:
                                            hasVoted
                                                ? AppColors.darkBrown
                                                : AppColors.mochaBrown,
                                        fontWeight:
                                            hasVoted
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            hasVoted
                                                ? [
                                                  AppColors.deepAmber
                                                      .withOpacity(0.7),
                                                  AppColors.caramel.withOpacity(
                                                    0.9,
                                                  ),
                                                ]
                                                : [
                                                  AppColors.brown.withOpacity(
                                                    0.15,
                                                  ),
                                                  AppColors.mochaBrown
                                                      .withOpacity(0.25),
                                                ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              hasVoted
                                                  ? AppColors.deepAmber
                                                      .withOpacity(0.1)
                                                  : AppColors.mochaBrown
                                                      .withOpacity(0.05),
                                          blurRadius: 2,
                                          spreadRadius: 0,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${percentage.toStringAsFixed(0)}% (${option.votes.length})',
                                      style: TextStyle(
                                        color:
                                            hasVoted
                                                ? AppColors.cream
                                                : AppColors.brown,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  height: 12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.cream.withOpacity(0.3),
                                  ),
                                  child: Row(
                                    children: [
                                      if (percentage > 0)
                                        Container(
                                          height: 12,
                                          width:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  110) *
                                              (percentage / 100),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors:
                                                  hasVoted
                                                      ? [
                                                        AppColors.deepAmber,
                                                        AppColors.caramel,
                                                      ]
                                                      : [
                                                        AppColors.deepAmber
                                                            .withOpacity(0.5),
                                                        AppColors.caramel
                                                            .withOpacity(0.5),
                                                      ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            // Post actions
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.cream.withOpacity(0.05),
                    AppColors.lightCream.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(color: AppColors.brown.withOpacity(0.1)),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPostAction(
                    icon:
                        post.likes.contains(widget.currentUserId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                    color:
                        post.likes.contains(widget.currentUserId)
                            ? Colors.red
                            : AppColors.mochaBrown,
                    label: post.likes.length.toString(),
                    onPressed: () => _likePost(post.id),
                  ),
                  _buildPostAction(
                    icon: Icons.comment,
                    color: AppColors.mochaBrown,
                    label: post.comments.length.toString(),
                    onPressed: () {
                      // Show comments
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => _buildCommentsSheet(post),
                      );
                    },
                  ),
                  if (post.isQuestion)
                    _buildPostAction(
                      icon:
                          post.isResolved
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                      color:
                          post.isResolved
                              ? AppColors.oliveGreen
                              : AppColors.mochaBrown,
                      label: post.isResolved ? "Resolved" : "Mark Resolved",
                      onPressed: () => _toggleResolvedStatus(post.id),
                    )
                  else
                    _buildPostAction(
                      icon: Icons.share,
                      color: AppColors.mochaBrown,
                      label: "",
                      onPressed: () {
                        _showSnackBar("Sharing post...");
                      },
                    ),
                ],
              ),
            ),

            // Preview of comments
            if (post.comments.isNotEmpty)
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _buildCommentsSheet(post),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cream.withOpacity(0.05),
                        AppColors.lightCream.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border(
                      top: BorderSide(color: AppColors.brown.withOpacity(0.1)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 16,
                                color: AppColors.mochaBrown,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Latest comment',
                                style: TextStyle(
                                  color: AppColors.mochaBrown,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.brown.withOpacity(0.15),
                                  AppColors.mochaBrown.withOpacity(0.25),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mochaBrown.withOpacity(0.05),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'View all ${post.comments.length}',
                                  style: TextStyle(
                                    color: AppColors.cream,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: AppColors.cream,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.brown.withOpacity(0.2),
                                  AppColors.caramel.withOpacity(0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mochaBrown.withOpacity(0.05),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.person,
                                color: AppColors.mochaBrown,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      post.comments.last.username,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.darkBrown,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.brown.withOpacity(0.1),
                                            AppColors.mochaBrown.withOpacity(
                                              0.15,
                                            ),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        post.comments.last.timeAgo,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.brown.withOpacity(
                                            0.7,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  post.comments.last.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkBrown,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSheet(Post post) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cream.withOpacity(0.2),
            AppColors.lightCream.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBrown.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.mochaBrown.withOpacity(0.3),
                      AppColors.mochaBrown.withOpacity(0.5),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cream.withOpacity(0.1),
                      AppColors.lightCream.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.brown.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.caramelToMochaGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mochaBrown.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 0,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.comment,
                            color: AppColors.cream,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.brown.withOpacity(0.15),
                            AppColors.mochaBrown.withOpacity(0.25),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mochaBrown.withOpacity(0.05),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        '${post.comments.length} ${post.comments.length == 1 ? 'comment' : 'comments'}',
                        style: TextStyle(
                          color: AppColors.cream,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    post.comments.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.cream.withOpacity(0.2),
                                      AppColors.caramel.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.mochaBrown.withOpacity(
                                        0.05,
                                      ),
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  color: AppColors.mochaBrown.withOpacity(0.5),
                                  size: 48,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  color: AppColors.mochaBrown,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                post.isQuestion
                                    ? 'Be the first to answer this question!'
                                    : 'Be the first to share your thoughts',
                                style: TextStyle(
                                  color: AppColors.mochaBrown.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppColors.caramelToMochaGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.mochaBrown.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextButton.icon(
                                  icon: Icon(
                                    Icons.add_comment,
                                    color: AppColors.cream,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Add Comment',
                                    style: TextStyle(
                                      color: AppColors.cream,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Focus on comment input
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          controller: scrollController,
                          itemCount: post.comments.length,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          separatorBuilder:
                              (context, index) => Divider(
                                color: AppColors.mochaBrown.withOpacity(0.1),
                                height: 1,
                                indent: 64,
                                endIndent: 16,
                              ),
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          comment.userId != null
                                              ? AppColors.brown
                                              : AppColors.cream.withOpacity(
                                                0.7,
                                              ),
                                          comment.userId != null
                                              ? AppColors.caramel.withOpacity(
                                                0.8,
                                              )
                                              : AppColors.caramel.withOpacity(
                                                0.5,
                                              ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.mochaBrown
                                              .withOpacity(0.1),
                                          blurRadius: 3,
                                          spreadRadius: 0,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Icon(
                                        Icons.person,
                                        color:
                                            comment.userId != null
                                                ? AppColors.cream
                                                : AppColors.mochaBrown,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.username,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: AppColors.darkBrown,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.brown.withOpacity(
                                                      0.1,
                                                    ),
                                                    AppColors.mochaBrown
                                                        .withOpacity(0.2),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                comment.timeAgo,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.mochaBrown,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 6),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.cream.withOpacity(
                                                  0.1,
                                                ),
                                                AppColors.lightCream
                                                    .withOpacity(0.2),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            border: Border.all(
                                              color: AppColors.mochaBrown
                                                  .withOpacity(0.1),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.mochaBrown
                                                    .withOpacity(0.03),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            comment.content,
                                            style: TextStyle(
                                              color: AppColors.darkBrown,
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cream.withOpacity(0.15),
                      AppColors.lightCream.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBrown.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, -3),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: AppColors.mochaBrown.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.caramelToMochaGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mochaBrown.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.person,
                          color: AppColors.cream,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mochaBrown.withOpacity(0.1),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _commentController,
                          style: TextStyle(color: AppColors.darkBrown),
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText:
                                post.isQuestion
                                    ? 'Add your answer...'
                                    : 'Add a comment...',
                            hintStyle: TextStyle(
                              color: AppColors.mochaBrown.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: AppColors.mochaBrown.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: AppColors.caramel,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: AppColors.mochaBrown.withOpacity(0.3),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.lightCream.withOpacity(0.5),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.attach_file,
                                color: AppColors.mochaBrown,
                              ),
                              onPressed: () {
                                _showSnackBar(
                                  "Attachment feature coming soon!",
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.caramelToMochaGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mochaBrown.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: AppColors.cream,
                          size: 20,
                        ),
                        onPressed: () {
                          _addComment(post.id);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCreatePostCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shadowColor: AppColors.mochaBrown.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.mochaBrown.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.cream.withOpacity(0.15),
              AppColors.lightCream.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.caramelToMochaGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mochaBrown.withOpacity(0.2),
                        blurRadius: 3,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person, color: AppColors.cream),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.currentUserId != null
                            ? 'Post as User_${widget.currentUserId}'
                            : 'Post anonymously',
                        style: TextStyle(
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _isQuestion
                                      ? AppColors.oliveGreen.withOpacity(0.7)
                                      : _isCreatingPoll
                                      ? AppColors.deepAmber.withOpacity(0.7)
                                      : AppColors.mochaBrown.withOpacity(0.1),
                                  _isQuestion
                                      ? AppColors.sage.withOpacity(0.8)
                                      : _isCreatingPoll
                                      ? AppColors.caramel.withOpacity(0.8)
                                      : AppColors.mochaBrown.withOpacity(0.2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mochaBrown.withOpacity(0.05),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isQuestion
                                      ? Icons.help_outline
                                      : _isCreatingPoll
                                      ? Icons.poll
                                      : Icons.post_add,
                                  size: 14,
                                  color:
                                      _isQuestion || _isCreatingPoll
                                          ? AppColors.cream
                                          : AppColors.mochaBrown,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  _isQuestion
                                      ? 'Question'
                                      : _isCreatingPoll
                                      ? 'Poll'
                                      : 'Post',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        _isQuestion || _isCreatingPoll
                                            ? AppColors.cream
                                            : AppColors.mochaBrown,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          PopupMenuButton<String>(
                            offset: Offset(0, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) {
                              setState(() {
                                if (value == 'question') {
                                  _isQuestion = true;
                                  _isCreatingPoll = false;
                                } else if (value == 'poll') {
                                  _isCreatingPoll = true;
                                  _isQuestion = false;
                                } else {
                                  _isQuestion = false;
                                  _isCreatingPoll = false;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              child: Text(
                                'Change type',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.caramel,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    value: 'post',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.post_add,
                                          color: AppColors.mochaBrown,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Regular Post'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'question',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.help_outline,
                                          color: AppColors.oliveGreen,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Question'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'poll',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.poll,
                                          color: AppColors.deepAmber,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Poll'),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _postController,
              maxLines: 3,
              style: TextStyle(color: AppColors.darkBrown),
              decoration: InputDecoration(
                hintText:
                    _isQuestion
                        ? 'Ask your question here...'
                        : _isCreatingPoll
                        ? 'What would you like to ask in your poll?'
                        : 'Share something with the community...',
                hintStyle: TextStyle(
                  color: AppColors.mochaBrown.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.mochaBrown.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.caramel, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.mochaBrown.withOpacity(0.3),
                  ),
                ),
                fillColor: AppColors.lightCream.withOpacity(0.5),
                filled: true,
                contentPadding: EdgeInsets.all(16),
              ),
            ),

            // Poll options
            if (_isCreatingPoll) ...[
              const SizedBox(height: 16),
              Text(
                'Poll Options',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(_pollOptionControllers.length, (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mochaBrown.withOpacity(0.05),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pollOptionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            hintStyle: TextStyle(
                              color: AppColors.mochaBrown.withOpacity(0.6),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.mochaBrown.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.deepAmber,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.mochaBrown.withOpacity(0.3),
                              ),
                            ),
                            fillColor: AppColors.lightCream.withOpacity(0.5),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      if (_pollOptionControllers.length > 2)
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _removePollOption(index),
                          splashRadius: 20,
                        ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                icon: Icon(Icons.add_circle, color: AppColors.deepAmber),
                label: Text(
                  'Add Option',
                  style: TextStyle(
                    color: AppColors.deepAmber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: _addPollOption,
              ),
            ],

            if (_imageFile != null) ...[
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.mochaBrown.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mochaBrown.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _imageFile!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.mochaBrown.withOpacity(0.8),
                            AppColors.darkBrown.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkBrown.withOpacity(0.2),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.cream,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Tags input
            if (!_isCreatingPoll) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add tags (optional)',
                        hintStyle: TextStyle(
                          color: AppColors.mochaBrown.withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppColors.mochaBrown.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppColors.softTeal,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppColors.mochaBrown.withOpacity(0.3),
                          ),
                        ),
                        fillColor: AppColors.lightCream.withOpacity(0.5),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        prefixIcon: Icon(Icons.tag, color: AppColors.softTeal),
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.softTeal.withOpacity(0.7),
                            AppColors.softTeal,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.softTeal.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(Icons.add, color: AppColors.cream, size: 20),
                    ),
                    onPressed: _addTag,
                  ),
                ],
              ),
            ],

            if (_selectedTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _selectedTags.map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.softTeal.withOpacity(0.2),
                              AppColors.softTeal.withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.softTeal.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.softTeal.withOpacity(0.1),
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '#$tag',
                              style: TextStyle(
                                color: AppColors.softTeal,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _removeTag(tag),
                              child: Icon(
                                Icons.close,
                                color: AppColors.softTeal,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],

            // Subject selector
            if (!_isCreatingPoll) ...[
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cream.withOpacity(0.1),
                      AppColors.caramel.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.mochaBrown.withOpacity(0.2),
                  ),
                ),
                child: DropdownButton<String>(
                  value: _selectedPostSubject,
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.mochaBrown,
                  ),
                  style: TextStyle(color: AppColors.darkBrown, fontSize: 14),
                  dropdownColor: AppColors.lightCream,
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPostSubject = newValue!;
                    });
                  },
                  items:
                      _subjects
                          .where((subject) => subject != 'All')
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 16,
                                    color: AppColors.mochaBrown,
                                  ),
                                  SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          })
                          .toList(),
                  hint: Text(
                    'Select Subject',
                    style: TextStyle(
                      color: AppColors.mochaBrown.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ],

            // Post actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (!_isCreatingPoll)
                      _buildActionButton(
                        icon: Icons.image,
                        label: 'Image',
                        onPressed: _pickImage,
                        color: AppColors.softTeal,
                      ),
                    if (!_isCreatingPoll)
                      _buildActionButton(
                        icon: Icons.attach_file,
                        label: 'Attach',
                        onPressed: () {
                          _showSnackBar("Attachment feature coming soon!");
                        },
                        color: AppColors.caramel,
                      ),
                  ],
                ),
                _buildActionButton(
                  icon: Icons.send,
                  label: 'Post',
                  onPressed: _createPost,
                  color: AppColors.cream,
                  textColor: AppColors.cream,
                  gradient: AppColors.caramelToMochaGradient,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 7) {
      return "${(difference.inDays / 7).floor()}w ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter posts based on selected tab and subject
    List<Post> filteredPosts =
        _posts.where((post) {
          bool matchesTab =
              _tabController.index == 0 ||
              (_tabController.index == 1 && post.isQuestion) ||
              (_tabController.index == 2 && post.isPoll);

          bool matchesSubject =
              _selectedSubject == 'All' || post.subject == _selectedSubject;

          return matchesTab && matchesSubject;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.lightCream.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        elevation: 0,
        title: Text(
          'Student Community',
          style: TextStyle(
            color: AppColors.cream,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.cream),
            onPressed: () {
              _showSnackBar("Search feature coming soon!");
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.cream),
            onPressed: () {
              _showSnackBar("Notifications feature coming soon!");
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.creamToAmberGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBrown.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.person, color: AppColors.darkBrown),
              onPressed: () {
                _showSnackBar("Profile feature coming soon!");
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.darkBrown,
                  AppColors.mochaBrown.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBrown.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.cream,
              indicatorWeight: 3,
              labelColor: AppColors.cream,
              unselectedLabelColor: AppColors.cream.withOpacity(0.7),
              tabs: [
                Tab(text: 'All Posts'),
                Tab(text: 'Questions'),
                Tab(text: 'Polls'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Subject filter chips
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              gradient: LinearGradient(
                colors: [
                  AppColors.cream.withOpacity(0.2),
                  AppColors.lightCream.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBrown.withOpacity(0.05),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final isSelected = _selectedSubject == subject;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(subject),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.cream : AppColors.darkBrown,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.cream.withOpacity(0.1),
                    selectedColor: AppColors.caramel,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color:
                            isSelected
                                ? AppColors.caramel
                                : AppColors.mochaBrown.withOpacity(0.3),
                      ),
                    ),
                    shadowColor: AppColors.mochaBrown.withOpacity(0.2),
                    elevation: isSelected ? 2 : 0,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSubject = subject;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Main content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Simulate refreshing posts
                await Future.delayed(Duration(seconds: 1));
                _showSnackBar("Feed refreshed");
              },
              color: AppColors.caramel,
              backgroundColor: AppColors.cream.withOpacity(0.9),
              child: ListView(
                padding: EdgeInsets.only(top: 8, bottom: 80),
                children: [
                  // Post creation card
                  _buildCreatePostCard(),

                  // Posts list
                  ...filteredPosts.map((post) => _buildPostCard(post)).toList(),

                  // Empty state if no posts
                  if (filteredPosts.isEmpty)
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 16,
                      ),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.cream.withOpacity(0.2),
                            AppColors.lightCream.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.mochaBrown.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mochaBrown.withOpacity(0.05),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.cream.withOpacity(0.3),
                                  AppColors.caramel.withOpacity(0.2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mochaBrown.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _tabController.index == 1
                                  ? Icons.help_outline
                                  : _tabController.index == 2
                                  ? Icons.poll
                                  : Icons.post_add,
                              color: AppColors.mochaBrown.withOpacity(0.7),
                              size: 48,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _tabController.index == 1
                                ? 'No questions yet'
                                : _tabController.index == 2
                                ? 'No polls yet'
                                : 'No posts yet',
                            style: TextStyle(
                              color: AppColors.darkBrown,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _tabController.index == 1
                                ? 'Be the first to ask a question!'
                                : _tabController.index == 2
                                ? 'Create a poll to gather opinions'
                                : 'Start the conversation',
                            style: TextStyle(
                              color: AppColors.mochaBrown.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Scroll to top of the create post card
          Scrollable.ensureVisible(
            context,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Icon(Icons.add, color: AppColors.cream),
        backgroundColor: AppColors.caramel,
        foregroundColor: AppColors.cream,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
