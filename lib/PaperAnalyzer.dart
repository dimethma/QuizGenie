import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:firebase_core/firebase_core.dart';

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
                    onCreated:
                        (controller) =>
                            setState(() => dropzoneController = controller),
                    onDrop: handleDrop,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                      Text("Drag & drop a file to upload"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pickFiles,
                        child: Text("Choose File"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: uploadedFiles.length,
                itemBuilder:
                    (context, index) => ListTile(
                      title: Text(uploadedFiles[index]),
                      leading: Icon(Icons.file_present),
                    ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: analyzePapers,
              child: Text("Analyze Papers"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.group), label: 'Groups'),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
