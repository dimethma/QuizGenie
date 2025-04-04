import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TopicBreakdownAnalyzer extends StatefulWidget {
  const TopicBreakdownAnalyzer({super.key});

  @override
  State<TopicBreakdownAnalyzer> createState() => _TopicBreakdownAnalyzerState();
}

class _TopicBreakdownAnalyzerState extends State<TopicBreakdownAnalyzer> {
  bool _isLoading = false;

  File? selectedFile;
  List<Map<String, dynamic>> topics = [];

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      if (!mounted) return;

      setState(() {
        selectedFile = File(result.files.single.path!);
      });

      // Ensure dialog shows after the widget is still mounted
      if (!mounted) return;

      // Use 'await' to pause until user closes the dialog
      await showDialog(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text("Success"),
              content: const Text("File loaded successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss dialog only
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  child: const Text("OK",
                  style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
      );
    }
  }

  Future<void> analyzeTopics() async {
    if (selectedFile == null) return;

    setState(() {
      _isLoading = true;
      topics.clear(); // Optional: clear previous results
    });

    final uri = Uri.parse(
      'http://10.244.144.122:5000/analyze-topics',
    ); // Update IP for real device

    try {
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('files', selectedFile!.path),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          throw Exception("Connection timed out. Check backend IP or network.");
        },
      );

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final decoded = json.decode(resBody);
        setState(() {
          topics = List<Map<String, dynamic>>.from(decoded['topics']);
        });
      } else {
        debugPrint('Failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to analyze the file')),
        );
      }
    } catch (e) {
      debugPrint("❌ Error occurred: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: const Text("Topic Breakdown Analyzer",
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
            
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),

        ),
            ],
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            const Text(
              'Step 1: Upload File',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text('Drag & drop a file to upload'),
                  const SizedBox(height: 6),
                  const Text(
                    'DropzoneView: TargetPlatform.android is not supported',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Choose Files',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : analyzeTopics,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5200),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : const Text(
                        'AI Topic Breakdown',
                        style: TextStyle(color: Colors.white),
                      ),
            ),
            const SizedBox(height: 20),
            if (topics.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${topic['topic']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...List.from(
                              topic['features'],
                            ).map((f) => Text("- $f")).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF9A7300),
        unselectedItemColor: const Color(0xFF6A5200),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
    _showCreationOptions(context);
  },
        backgroundColor: const Color(0xFFD28A56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Small handle indicator at top
                Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.create, color: Colors.white),
                  title: Text(
                    'Create New Paper',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePaperScreen(),
                      ),
                    );
                  },
                ),
                Divider(color: Colors.white.withOpacity(0.2), height: 1),
                ListTile(
                  leading: Icon(Icons.upload, color: Colors.white),
                  title: Text(
                    'Upload Existing Paper',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadOptionsScreen(),
                      ),
                    );
                  },
                ),
                Divider(color: Colors.white.withOpacity(0.2), height: 1),
                ListTile(
                  leading: Icon(Icons.file_copy, color: Colors.white),
                  title: Text(
                    'Browse Templates',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TemplateGalleryScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CreatePaperScreen extends StatefulWidget {
  const CreatePaperScreen({super.key});

  @override
  State<CreatePaperScreen> createState() => _CreatePaperScreenState();
}

class _CreatePaperScreenState extends State<CreatePaperScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _paperType = 'MCQ';
  String _subject = 'Mathematics';
  String _difficulty = 'Medium';
  int _questionCount = 10;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: const Text(
          'Create New Paper',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _savePaper,
            tooltip: 'Save Paper',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Paper Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter paper title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paperType,
                items:
                    ['MCQ', 'Essay', 'Mixed'].map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (value) {
                  setState(() => _paperType = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Paper Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _subject,
                items:
                    ['Mathematics', 'DBMS', 'C#', 'SDTP', 'English'].map((
                      subject,
                    ) {
                      return DropdownMenuItem(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() => _subject = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _difficulty,
                items:
                    ['Easy', 'Medium', 'Hard'].map((level) {
                      return DropdownMenuItem(value: level, child: Text(level));
                    }).toList(),
                onChanged: (value) {
                  setState(() => _difficulty = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Difficulty Level',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _questionCount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _questionCount = int.tryParse(value) ?? 10;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePaper,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromARGB(255, 107, 83, 2),
                ),
                child: const Text(
                  'Generate Paper',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePaper() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Generating your paper...')));
      // TODO: Implement paper generation logic
      Navigator.pop(context);
    }
  }
}

class TemplateGalleryScreen extends StatefulWidget {
  const TemplateGalleryScreen({super.key});

  @override
  State<TemplateGalleryScreen> createState() => _TemplateGalleryScreenState();
}

class _TemplateGalleryScreenState extends State<TemplateGalleryScreen> {
  final List<Map<String, dynamic>> _templates = [
    {
      'title': 'Math Quiz',
      'type': 'MCQ',
      'subject': 'Mathematics',
      'questions': 20,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor': Colors.white.withOpacity(0.2),
    },
    {
      'title': 'DBMS Essay',
      'type': 'Essay',
      'subject': 'DBMS',
      'questions': 5,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor': Colors.white.withOpacity(0.2),
    },
    {
      'title': 'C# Test',
      'type': 'Mixed',
      'subject': 'C#',
      'questions': 15,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor': Colors.white.withOpacity(0.2),
    },
    {
      'title': 'English Grammar',
      'type': 'MCQ',
      'subject': 'English',
      'questions': 25,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor': Colors.white.withOpacity(0.2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: const Text(
          'Paper Templates',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: _templates.length,
        itemBuilder: (context, index) {
          final template = _templates[index];
          return _buildTemplateCard(template);
        },
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onTemplateSelected(template),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: template['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description,
                  color: template['color'],
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                template['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                template['subject'],
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '${template['questions']} questions',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(template['type']),
                backgroundColor: template['color'].withOpacity(0.1),
                labelStyle: TextStyle(color: template['color']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTemplateSelected(Map<String, dynamic> template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateDetailScreen(template: template),
      ),
    );
  }
}

class TemplateDetailScreen extends StatelessWidget {
  final Map<String, dynamic> template;

  const TemplateDetailScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: Text(
          template['title'],
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Subject', template['subject']),
            _buildDetailItem('Type', template['type']),
            _buildDetailItem('Questions', template['questions'].toString()),
            _buildDetailItem('Difficulty', 'Medium'),
            const SizedBox(height: 30),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This template includes a variety of question types carefully selected to assess student understanding of the subject matter.',
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicBreakdownAnalyzer(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromARGB(255, 107, 83, 2),
                ),
                child: const Text(
                  'Use This Template',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    ),
  );
}

class UploadOptionsScreen extends StatelessWidget {
  const UploadOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: const Text(
          'Upload Paper',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUploadOption(
              context,
              icon: Icons.photo_library,
              label: 'From Gallery',
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
            const SizedBox(height: 20),
            _buildUploadOption(
              context,
              icon: Icons.camera_alt,
              label: 'Take Photo',
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            const SizedBox(height: 20),
            _buildUploadOption(
              context,
              icon: Icons.insert_drive_file,
              label: 'Choose File',
              onTap: () => _pickDocument(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 30),
                const SizedBox(width: 20),
                Text(label, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => FilePreviewScreen(
                  filePath: pickedFile.path,
                  fileType: 'image',
                ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _pickDocument(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => FilePreviewScreen(
                  filePath: result.files.single.path!,
                  fileType: 'document',
                ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}

class FilePreviewScreen extends StatelessWidget {
  final String filePath;
  final String fileType;

  const FilePreviewScreen({
    super.key,
    required this.filePath,
    required this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: const Text(
          'Preview',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProcessingScreen(filePath: filePath),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child:
            fileType == 'image'
                ? Image.file(File(filePath))
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.insert_drive_file, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      filePath.split('/').last,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
      ),
    );
  }
}

class ProcessingScreen extends StatefulWidget {
  final String filePath;

  const ProcessingScreen({super.key, required this.filePath});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool _isProcessing = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _processFile();
  }

  Future<void> _processFile() async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _isSuccess = true; // Change to false to simulate failure
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: const Text(
          'Processing',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'poppins',
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 107, 83, 2),
                Color.fromARGB(255, 53, 47, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child:
            _isProcessing
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Analyzing your document...'),
                  ],
                )
                : _isSuccess
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Analysis Complete',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'File: ${widget.filePath.split('/').last}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                          255,
                          107,
                          83,
                          2,
                        ), // Background color
                        foregroundColor:
                            Colors
                                .white, // Text color (alternative to TextStyle)
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ), // Button padding
                      ),

                      child: const Text(
                        'View Results',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 80),
                    const SizedBox(height: 20),
                    const Text(
                      'Processing Failed',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const Text('Could not analyze the document'),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
      ),
    );
  }
}

class QuizResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final List<String> sourceFiles;

  const QuizResultsScreen({
    Key? key,
    required this.questions,
    required this.sourceFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generated Questions')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionCard(question: question, index: index);
              },
            ),
          ),
          if (sourceFiles.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Generated from ${sourceFiles.length} source file(s)',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final int index;

  const QuestionCard({Key? key, required this.question, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}: ${question['question']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (question['type'] == 'MCQ') ...[
              SizedBox(height: 8),
              ...List<Widget>.from(
                question['options'].map<Widget>((option) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '- $option',
                      style: TextStyle(
                        color:
                            option == question['correct_answer']
                                ? Colors.green
                                : Colors.black,
                        fontWeight:
                            option == question['correct_answer']
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  );
                }),
              ),
            ],
            SizedBox(height: 8),
            Text(
              'Correct Answer: ${question['correct_answer']}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Explanation: ${question['explanation']}',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            if (question['source'] != null) ...[
              SizedBox(height: 8),
              Text(
                'Source Context:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                question['source'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
