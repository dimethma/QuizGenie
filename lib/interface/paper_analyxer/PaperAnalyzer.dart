import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class PaperAnalyzer extends StatefulWidget {
  @override
  _PaperAnalyzerState createState() => _PaperAnalyzerState();
}

class _PaperAnalyzerState extends State<PaperAnalyzer> {
  DropzoneViewController? dropzoneController;
  List<String> uploadedFiles = [];
  int _selectedIndex = 0;
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> pickFiles() async {
    if (uploadedFiles.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only upload up to 5 papers.")),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        if (uploadedFiles.length >= 5) break;
        await uploadFile(file);
      }
    }
  }

  Future<void> uploadFile(PlatformFile file) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(
        "papers/${file.name}",
      );
      await ref.putData(file.bytes!);
      String downloadURL = await ref.getDownloadURL();
      setState(() {
        uploadedFiles.add(downloadURL);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }
  Future<void> generateQuestions(String type) async {
    Navigator.pop(context);
    int numQuestions = type == "MCQ" ? 50 : 5;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        Uri.parse('http://192.168.1.100:5000/generate_questions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': type,
          'subject': 'Mathematics', // Make dynamic based on user input
          'difficulty': 'Medium',  // Make dynamic based on user input
          'num_questions': numQuestions,
          'files': uploadedFiles, // Send all uploaded file URLs
        }),
      );

      Navigator.pop(context); // Dismiss loading

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        await FirebaseFirestore.instance.collection("generated_quizzes").add({
          "type": type,
          "num_questions": numQuestions,
          "source_files": uploadedFiles,
          "questions": data['questions'],
          "timestamp": Timestamp.now(),
          "model": data['model'],
          "usage": data['usage'],
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultsScreen(
              questions: List<Map<String, dynamic>>.from(data['questions']),
              sourceFiles: uploadedFiles,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  Future<void> handleDrop(dynamic file) async {
    try {
      if (dropzoneController == null) return;

      String name = await dropzoneController!.getFilename(file);
      final bytes = await dropzoneController!.getFileData(file);

      Reference ref = FirebaseStorage.instance.ref().child("papers/$name");
      await ref.putData(bytes);
      String downloadURL = await ref.getDownloadURL();

      setState(() {
        uploadedFiles.add(downloadURL);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error uploading file: $e")));
    }
  }

  void analyzePapers() {
    if (uploadedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload at least one paper.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Select Question Type"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => generateQuestions("MCQ"),
                  child: Text("MCQ Questions"),
                ),
                ElevatedButton(
                  onPressed: () => generateQuestions("Essay"),
                  child: Text("Essay Questions"),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> generatesQuestions(String type) async {
    Navigator.pop(context);
    int numQuestions = type == "MCQ" ? 50 : 5;

    FirebaseFirestore.instance.collection("generated_quizzes").add({
      "type": type,
      "num_questions": numQuestions,
      "papers": uploadedFiles,
      "timestamp": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$numQuestions $type questions generated!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(224, 238, 237, 236),
      appBar: AppBar(
        title: Text(
          "Generate Your Paper",
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
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    _showCreationOptions(context);
  },
  child: Icon(Icons.add,
   color: Color.fromARGB(255, 244, 213, 130)), // AppColors.cream equivalent
  backgroundColor: Color.fromARGB(255, 196, 132, 86), // AppColors.caramel equivalent
  foregroundColor: Color.fromARGB(255, 244, 213, 130), // AppColors.cream equivalent
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
),
      body: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Text(
          "Step 1: Upload File",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              DropzoneView(
                onCreated: (controller) => setState(() => dropzoneController = controller),
                onDrop: handleDrop,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                  Text("Drag & drop a file to upload"),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: pickFiles,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(255, 107, 83, 2),
                    ),
                    child: const Text('Choose Files',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Moved the Analyze Paper button here, right after the dropzone
        ElevatedButton(
          onPressed: analyzePapers,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromARGB(255, 107, 83, 2),
            minimumSize: Size(double.infinity, 50), // Making it full width
          ),
          child: const Text('Analyze Paper',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: uploadedFiles.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(uploadedFiles[index]),
              leading: Icon(Icons.file_present),
            ),
          ),
        ),
        // Analysis Progress UI to be placed under the "Analyze Paper" button
Container(
  width: double.infinity,
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFF292919),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Analysis Progress section
      Text(
        "Analysis Progress",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      LinearProgressIndicator(
        value: 0.0, // 0% completed
        backgroundColor: Colors.grey.shade800,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8A765)),
        minHeight: 8,
        borderRadius: BorderRadius.circular(4),
      ),
      SizedBox(height: 4),
      Text(
        "0% completed",
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
        ),
      ),
      SizedBox(height: 24),
      
      // Content Breakdown section
      Text(
        "Content Breakdown",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      Text(
        "100%",
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        children: [
          Text(
            "Current Analysis ",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          Text(
            "+0%",
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 24),
      
      // Sets section
      Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "Sets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8A765)),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      
      // Normal Distribution section
      Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "Normal Distribution",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: 0.9,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8A765)),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      
      // Fractions section
      Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "Fractions",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8A765)),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      
      // Others section
      Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "Others",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8A765)),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    ],
  ),
)
      ],
    ),
  ),
  // Bottom Navigation Bar
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    selectedItemColor: const Color.fromARGB(255, 177, 120, 35),
    unselectedItemColor: const Color.fromARGB(255, 78, 44, 4),
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        label: 'Resources',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
            icon: const Icon(Icons.save,color: Colors.white),
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
                items: ['MCQ', 'Essay', 'Mixed'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
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
                items: ['Mathematics', 'DBMS', 'C#', 'SDTP', 'English'].map((subject) {
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
                items: ['Easy', 'Medium', 'Hard'].map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
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
                child: const Text('Generate Paper',
                style: TextStyle(color: Colors.white , fontSize: 16),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePaper() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating your paper...')),
      );
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
      'backgroundColor':Colors.white.withOpacity(0.2),
    },
    {
      'title': 'DBMS Essay',
      'type': 'Essay',
      'subject': 'DBMS',
      'questions': 5,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor':Colors.white.withOpacity(0.2),
    },
    {
      'title': 'C# Test',
      'type': 'Mixed',
      'subject': 'C#',
      'questions': 15,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor':Colors.white.withOpacity(0.2),
      
    },
    {
      'title': 'English Grammar',
      'type': 'MCQ',
      'subject': 'English',
      'questions': 25,
      'color': Color.fromARGB(255, 196, 132, 86),
      'backgroundColor':Colors.white.withOpacity(0.2),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${template['questions']} questions',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(template['type']),
                backgroundColor: template['color'].withOpacity(0.1),
                labelStyle: TextStyle(
                  color: template['color'],
                ),
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
    body:  SingleChildScrollView(
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                      builder: (context) => PaperAnalyzer(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromARGB(255, 107, 83, 2),
                
                ),
                child: const Text('Use This Template',
                style: TextStyle(color: Colors.white , fontSize: 16),),), 
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
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
    body:  Center(
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
                Text(
                  label,
                  style: const TextStyle(fontSize: 18),
                ),
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
            builder: (context) => FilePreviewScreen(
              filePath: pickedFile.path,
              fileType: 'image',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
            builder: (context) => FilePreviewScreen(
              filePath: result.files.single.path!,
              fileType: 'document',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
            icon: const Icon(Icons.check,color: Colors.white,),
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
        child: fileType == 'image'
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
        child: _isProcessing
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
                      const Icon(Icons.check_circle, color: Colors.green, size: 80),
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
                      const SizedBox(height: 40,),
                      ElevatedButton(
                        
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 107, 83, 2), // Background color
                         foregroundColor: Colors.white, // Text color (alternative to TextStyle)
                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
                          ),
                        
                        child: const Text('View Results',
                        style: TextStyle(color: Colors.white , fontSize: 16), 
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
      appBar: AppBar(
        title: Text('Generated Questions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionCard(
                  question: question,
                  index: index,
                );
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

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
  }) : super(key: key);

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
              ...List<Widget>.from(question['options'].map<Widget>((option) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '- $option',
                    style: TextStyle(
                      color: option == question['correct_answer'] 
                          ? Colors.green 
                          : Colors.black,
                      fontWeight: option == question['correct_answer']
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              })),
            ],
            SizedBox(height: 8),
            Text(
              'Correct Answer: ${question['correct_answer']}',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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