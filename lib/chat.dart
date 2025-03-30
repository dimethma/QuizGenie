import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Refined color palette based on the shared image
class AppColors {
  static const Color cream = Color(0xFFF4D582); // F4D582
  static const Color darkBrown = Color(0xFF271D15); // 271D15
  static const Color black = Color(0xFF101713); // 101713
  static const Color brown = Color(0xFF874E29); // 874E29
  static const Color lightCream = Color(0xFFF8E4A8); // Lighter version of cream
  static const Color mediumBrown = Color(0xFFA97348); // Medium brown
  static const Color offWhite = Color(
    0xFFF7F5F0,
  ); // Off-white instead of pure white
}

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
  });

  String get username => userId != null ? "User_$userId" : "Anonymous";
}

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
    if (difference.inDays > 0) {
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

class FeedScreen extends StatefulWidget {
  final String? currentUserId;

  const FeedScreen({Key? key, this.currentUserId}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Post> _posts = [
    // Sample posts
    Post(
      id: '1',
      userId: '123',
      content: 'Beautiful sunset at the beach today!',
      imageUrl: 'https://example.com/sunset.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      comments: [
        Comment(
          id: '101',
          userId: '456',
          content: 'Amazing view! Where was this taken?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    Post(
      id: '2',
      userId: null,
      content: 'What\'s your favorite coffee?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isPoll: true,
      pollOptions: [
        PollOption(id: '1', text: 'Espresso', votes: ['user1', 'user2']),
        PollOption(id: '2', text: 'Cappuccino', votes: ['user3']),
        PollOption(id: '3', text: 'Latte', votes: ['user4', 'user5', 'user6']),
      ],
    ),
  ];

  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _imageFile;
  bool _isCreatingPoll = false;
  List<TextEditingController> _pollOptionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
    );

    setState(() {
      _posts.insert(0, newPost);
      _postController.clear();
      _imageFile = null;
      _isCreatingPoll = false;
      _pollOptionControllers = [
        TextEditingController(),
        TextEditingController(),
      ];
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
        );
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.darkBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightCream.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        elevation: 0,
        title: Text(
          'Community Feed',
          style: TextStyle(
            color: AppColors.cream,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.cream),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.cream),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: AppColors.brown.withOpacity(0.5),
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Post creation card
          Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 3,
            color: AppColors.cream.withOpacity(0.15),
            shadowColor: AppColors.brown.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.brown.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.brown,
                        child: Icon(Icons.person, color: AppColors.cream),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.currentUserId != null
                              ? 'Post as User_${widget.currentUserId}'
                              : 'Post anonymously',
                          style: TextStyle(
                            color: AppColors.darkBrown,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
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
                      hintText: 'Share something with the community...',
                      hintStyle: TextStyle(
                        color: AppColors.brown.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.brown.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.brown,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.brown.withOpacity(0.3),
                        ),
                      ),
                      fillColor: AppColors.offWhite,
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: 12),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.brown.withOpacity(0.3),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.darkBrown.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.all(8),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.cream,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    ...List.generate(
                      _pollOptionControllers.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _pollOptionControllers[index],
                                style: TextStyle(color: AppColors.darkBrown),
                                decoration: InputDecoration(
                                  hintText: 'Option ${index + 1}',
                                  hintStyle: TextStyle(
                                    color: AppColors.brown.withOpacity(0.7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.brown,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.brown.withOpacity(0.3),
                                    ),
                                  ),
                                  fillColor: AppColors.offWhite,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.brown.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: AppColors.brown,
                                  size: 18,
                                ),
                              ),
                              onPressed: () => _removePollOption(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.brown,
                      ),
                      label: Text(
                        'Add Option',
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: _addPollOption,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.image,
                        label: 'Photo',
                        onPressed: _isCreatingPoll ? null : _pickImage,
                        color:
                            _isCreatingPoll
                                ? AppColors.brown.withOpacity(0.4)
                                : AppColors.brown,
                      ),
                      _buildActionButton(
                        icon: Icons.poll,
                        label: 'Poll',
                        onPressed:
                            _imageFile != null
                                ? null
                                : () {
                                  setState(() {
                                    _isCreatingPoll = !_isCreatingPoll;
                                  });
                                },
                        color:
                            _imageFile != null
                                ? AppColors.brown.withOpacity(0.4)
                                : AppColors.brown,
                      ),
                      _buildActionButton(
                        icon: Icons.send,
                        label: 'Post',
                        onPressed: _createPost,
                        color: AppColors.darkBrown,
                        textColor: AppColors.cream,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Posts feed
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                final totalVotes =
                    post.isPoll && post.pollOptions != null
                        ? post.pollOptions!.fold(
                          0,
                          (prev, option) => prev + option.votes.length,
                        )
                        : 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  elevation: 2,
                  shadowColor: AppColors.brown.withOpacity(0.3),
                  color: AppColors.offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.cream, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post header
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cream.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                post.userId != null
                                    ? AppColors.brown
                                    : AppColors.cream,
                            child: Icon(
                              Icons.person,
                              color:
                                  post.userId != null
                                      ? AppColors.cream
                                      : AppColors.brown,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            post.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            post.isPoll ? 'Created a poll' : 'Shared a post',
                            style: TextStyle(
                              color: AppColors.brown.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brown.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getTimeAgo(post.timestamp),
                              style: TextStyle(
                                color: AppColors.brown,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
                              color: AppColors.black,
                              height: 1.4,
                            ),
                          ),
                        ),

                      // Post image
                      if (post.imageUrl != null)
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxHeight: 300),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.brown.withOpacity(0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              post.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: AppColors.cream.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
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
                                          style: TextStyle(
                                            color: AppColors.brown,
                                          ),
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
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.cream.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.brown.withOpacity(0.2),
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Poll: ${totalVotes} ${totalVotes == 1 ? 'vote' : 'votes'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBrown,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 12),
                              ...post.pollOptions!.map((option) {
                                final percentage = option.getPercentage(
                                  totalVotes,
                                );
                                final hasVoted =
                                    widget.currentUserId != null &&
                                    option.votes.contains(widget.currentUserId);

                                return GestureDetector(
                                  onTap: () => _voteOnPoll(post.id, option.id),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          hasVoted
                                              ? AppColors.brown.withOpacity(0.2)
                                              : AppColors.offWhite,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.brown.withOpacity(0.3),
                                        width: hasVoted ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (hasVoted)
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                margin: EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.brown,
                                                  shape: BoxShape.circle,
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
                                                          : AppColors.black,
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
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.brown
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${percentage.toStringAsFixed(0)}% (${option.votes.length})',
                                                style: TextStyle(
                                                  color: AppColors.brown,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 12,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.cream.withOpacity(
                                              0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
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
                                                    color:
                                                        hasVoted
                                                            ? AppColors.brown
                                                            : AppColors
                                                                .mediumBrown,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                ),
                                            ],
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
                          color: AppColors.cream.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: AppColors.brown.withOpacity(0.1),
                            ),
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
                                      : AppColors.brown,
                              label: post.likes.length.toString(),
                              onPressed: () => _likePost(post.id),
                            ),
                            _buildPostAction(
                              icon: Icons.comment,
                              color: AppColors.brown,
                              label: post.comments.length.toString(),
                              onPressed: () {
                                // Show comments
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder:
                                      (context) => _buildCommentsSheet(post),
                                );
                              },
                            ),
                            _buildPostAction(
                              icon: Icons.share,
                              color: AppColors.brown,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cream.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.brown.withOpacity(0.1),
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Latest comment',
                                      style: TextStyle(
                                        color: AppColors.brown,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'View all ${post.comments.length}',
                                      style: TextStyle(
                                        color: AppColors.brown,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: AppColors.brown
                                          .withOpacity(0.2),
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.brown,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              Text(
                                                post.comments.last.timeAgo,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.brown
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            post.comments.last.content,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.black,
                                            ),
                                            maxLines: 1,
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brown,
        foregroundColor: AppColors.cream,
        elevation: 4,
        onPressed: () {
          // Scroll to top
          // You'd need a ScrollController to implement this functionality
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    Color textColor = Colors.white,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: color.withOpacity(0.1),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildPostAction({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSheet(Post post) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBrown.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
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
                  color: AppColors.brown.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
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
                        Icon(Icons.comment, color: AppColors.brown, size: 20),
                        SizedBox(width: 8),
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
                    Text(
                      '${post.comments.length} ${post.comments.length == 1 ? 'comment' : 'comments'}',
                      style: TextStyle(
                        color: AppColors.brown,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
                              Icon(
                                Icons.chat_bubble_outline,
                                color: AppColors.brown.withOpacity(0.4),
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  color: AppColors.brown.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Be the first to share your thoughts',
                                style: TextStyle(
                                  color: AppColors.brown.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          controller: scrollController,
                          itemCount: post.comments.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                color: AppColors.brown.withOpacity(0.1),
                                height: 1,
                                indent: 64,
                              ),
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    comment.userId != null
                                        ? AppColors.brown
                                        : AppColors.cream,
                                child: Icon(
                                  Icons.person,
                                  color:
                                      comment.userId != null
                                          ? AppColors.cream
                                          : AppColors.brown,
                                  size: 18,
                                ),
                              ),
                              title: Row(
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
                                      color: AppColors.brown.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      comment.timeAgo,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.brown,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 4.0,
                                ),
                                child: Text(
                                  comment.content,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              isThreeLine: comment.content.length > 40,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
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
                  color: AppColors.offWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBrown.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(color: AppColors.brown.withOpacity(0.1)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.brown,
                      child: Icon(
                        Icons.person,
                        color: AppColors.cream,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(color: AppColors.darkBrown),
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(
                            color: AppColors.brown.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.brown.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.brown,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.brown.withOpacity(0.3),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: AppColors.cream.withOpacity(0.1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.brown,
                        shape: BoxShape.circle,
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

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
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
