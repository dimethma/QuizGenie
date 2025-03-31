import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PaperAnalyzer extends StatefulWidget {
  @override
  _PaperAnalyzerState createState() => _PaperAnalyzerState();
}

class _PaperAnalyzerState extends State<PaperAnalyzer> {
  List<String> uploadedFiles = [];
  int _selectedIndex = 0; // Track selected tab

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

  Future<void> generateQuestions(String type) async {
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
      backgroundColor: Color.fromARGB(255, 177, 120, 35),
      appBar: AppBar(title: Text("Paper Analyzer")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: pickFiles, child: Text("Upload Paper")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: analyzePapers,
              child: Text("Analyze Papers"),
            ),
            SizedBox(height: 20),
            Text("Uploaded Papers: ${uploadedFiles.length}/5"),
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
}
