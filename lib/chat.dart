import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Custom color palette based on the shared image
class AppColors {
  static const Color cream = Color(0xFFF4D582); // F4D582
  static const Color darkBrown = Color(0xFF271D15); // 271D15
  static const Color black = Color(0xFF101713); // 101713
  static const Color brown = Color(0xFF874E29); // 874E29
  static const Color white = Color(0xFFFFFFFF); // FFFFFF
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please log in to vote on polls"),
          duration: Duration(seconds: 2),
        ),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please log in to like posts"),
          duration: Duration(seconds: 2),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        title: Text(
          'Community Feed',
          style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold),
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
      ),
      body: Column(
        children: [
          // Post creation card
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.brown,
                        child: Icon(Icons.person, color: AppColors.cream),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.currentUserId != null
                              ? 'Post as User_${widget.currentUserId}'
                              : 'Post anonymously',
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _postController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share something with the community...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.cream),
                      ),
                      fillColor: AppColors.white,
                      filled: true,
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFile!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: AppColors.brown),
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                  if (_isCreatingPoll) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Poll Options',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ...List.generate(
                      _pollOptionControllers.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _pollOptionControllers[index],
                                decoration: InputDecoration(
                                  hintText: 'Option ${index + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fillColor: AppColors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: AppColors.brown,
                              ),
                              onPressed: () => _removePollOption(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.add, color: AppColors.brown),
                      label: Text(
                        'Add Option',
                        style: TextStyle(color: AppColors.brown),
                      ),
                      onPressed: _addPollOption,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.image, color: AppColors.brown),
                        label: Text(
                          'Photo',
                          style: TextStyle(color: AppColors.brown),
                        ),
                        onPressed: _isCreatingPoll ? null : _pickImage,
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.poll, color: AppColors.brown),
                        label: Text(
                          'Poll',
                          style: TextStyle(color: AppColors.brown),
                        ),
                        onPressed:
                            _imageFile != null
                                ? null
                                : () {
                                  setState(() {
                                    _isCreatingPoll = !_isCreatingPoll;
                                  });
                                },
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.send, color: AppColors.darkBrown),
                        label: Text(
                          'Post',
                          style: TextStyle(color: AppColors.darkBrown),
                        ),
                        onPressed: _createPost,
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
                    vertical: 5.0,
                    horizontal: 8.0,
                  ),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post header
                      ListTile(
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
                          ),
                        ),
                        title: Text(
                          post.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        subtitle: Text(
                          post.isPoll ? 'Created a poll' : 'Shared a post',
                          style: TextStyle(
                            color: AppColors.brown.withOpacity(0.7),
                          ),
                        ),
                        trailing: Text(
                          _getTimeAgo(post.timestamp),
                          style: TextStyle(
                            color: AppColors.black.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Post content
                      if (post.content.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            post.content,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        ),

                      // Post image
                      if (post.imageUrl != null)
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxHeight: 300),
                          child: Image.network(
                            post.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Image not available',
                                    style: TextStyle(color: AppColors.brown),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // Poll options
                      if (post.isPoll && post.pollOptions != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                post.pollOptions!.map((option) {
                                  final percentage = option.getPercentage(
                                    totalVotes,
                                  );
                                  final hasVoted =
                                      widget.currentUserId != null &&
                                      option.votes.contains(
                                        widget.currentUserId,
                                      );

                                  return GestureDetector(
                                    onTap:
                                        () => _voteOnPoll(post.id, option.id),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  option.text,
                                                  style: TextStyle(
                                                    color:
                                                        hasVoted
                                                            ? AppColors
                                                                .darkBrown
                                                            : AppColors.black,
                                                    fontWeight:
                                                        hasVoted
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${percentage.toStringAsFixed(0)}% (${option.votes.length})',
                                                style: TextStyle(
                                                  color: AppColors.brown,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.cream
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width:
                                                      (MediaQuery.of(
                                                            context,
                                                          ).size.width -
                                                          50) *
                                                      (percentage / 100),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        hasVoted
                                                            ? AppColors.brown
                                                            : AppColors.cream,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
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
                          ),
                        ),

                      // Post actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    post.likes.contains(widget.currentUserId)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        post.likes.contains(
                                              widget.currentUserId,
                                            )
                                            ? Colors.red
                                            : AppColors.brown,
                                  ),
                                  onPressed: () => _likePost(post.id),
                                ),
                                Text(
                                  post.likes.length.toString(),
                                  style: TextStyle(color: AppColors.brown),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.comment,
                                    color: AppColors.brown,
                                  ),
                                  onPressed: () {
                                    // Show comments
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder:
                                          (context) =>
                                              _buildCommentsSheet(post),
                                    );
                                  },
                                ),
                                Text(
                                  post.comments.length.toString(),
                                  style: TextStyle(color: AppColors.brown),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.share, color: AppColors.brown),
                              onPressed: () {
                                // Share functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Sharing post..."),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Preview of comments
                      if (post.comments.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Text(
                                'Latest comment:',
                                style: TextStyle(
                                  color: AppColors.brown,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColors.cream,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.brown,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.comments.last.username,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: AppColors.darkBrown,
                                          ),
                                        ),
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
                              TextButton(
                                child: Text(
                                  'View all ${post.comments.length} comments',
                                  style: TextStyle(
                                    color: AppColors.brown,
                                    fontSize: 12,
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder:
                                        (context) => _buildCommentsSheet(post),
                                  );
                                },
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brown,
        onPressed: () {
          // Scroll to top
          // You'd need a ScrollController to implement this functionality
        },
        child: Icon(Icons.arrow_upward, color: AppColors.cream),
      ),
    );
  }

  Widget _buildCommentsSheet(Post post) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              Expanded(
                child:
                    post.comments.isEmpty
                        ? Center(
                          child: Text(
                            'No comments yet. Be the first to comment!',
                            style: TextStyle(
                              color: AppColors.brown.withOpacity(0.7),
                            ),
                          ),
                        )
                        : ListView.builder(
                          controller: scrollController,
                          itemCount: post.comments.length,
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
                                      color: AppColors.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    comment.timeAgo,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  comment.content,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              isThreeLine: comment.content.length > 40,
                            );
                          },
                        ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 8.0,
                  right: 8.0,
                  top: 8.0,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.cream,
                      child: Icon(
                        Icons.person,
                        color: AppColors.brown,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColors.brown),
                      onPressed: () {
                        _addComment(post.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
