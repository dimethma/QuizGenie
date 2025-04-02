import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quizgenie/quiz_generator/quiz3.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

// Function to upload files to the API and get the generated questions
Future<List<Map<String, dynamic>>> _uploadFilesAndGenerateQuestions(
  List<String> _files,
) async {
  if (_files.isEmpty) {
    print('No files selected!');
    return [];
  }

  // API URL
  String url =
      'http://10.16.143.122:5000/generate-questions'; // Update if deployed

  // Prepare the files to send in the request
  var request = http.MultipartRequest('POST', Uri.parse(url));

  // Add the files to the request
  for (var filePath in _files) {
    var file = await http.MultipartFile.fromPath(
      'files', // Field name in the API
      filePath,
      contentType: MediaType('application', 'pdf'), // Assuming PDF files
    );
    request.files.add(file);
  }

  // Send the request and await the response
  var response = await request.send();

  if (response.statusCode == 200) {
    // If API call is successful, handle the response
    final responseBody = await response.stream.bytesToString();
    final data = json.decode(responseBody);

    // Extract the generated MCQ questions
    List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(
      data['questions'],
    );
    return questions;
  } else {
    print('Failed to generate questions: ${response.statusCode}');
    return [];
  }
}

class AddPapersPage extends StatefulWidget {
  @override
  _AddPapersPageState createState() => _AddPapersPageState();
}

class _AddPapersPageState extends State<AddPapersPage> {
  bool _isLoading = false;
  bool _questionsLoaded = false;
  List<Question> _generatedQuestions = [];

  List<String> _files = []; // List to store selected file paths
  final int _maxFiles = 5; // Maximum number of files allowed

  // Function to pick files using FilePicker
  void _pickFiles() async {
    if (_files.length >= _maxFiles) return; // Limit the number of files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple files to be selected
    );
    if (result != null) {
      setState(() {
        // Add selected files to the list, ensuring max limit is not exceeded
        _files.addAll(
          result.paths.map((path) => path!).take(_maxFiles - _files.length),
        );
      });
    }
  }

  // Function to process papers and generate questions
  void _processPapers() async {
    setState(() {
      _isLoading = true;
      _questionsLoaded = false;
    });

    List<Map<String, dynamic>> rawQuestions =
        await _uploadFilesAndGenerateQuestions(_files);

    setState(() {
      _isLoading = false;
    });

    if (rawQuestions.isNotEmpty) {
      setState(() {
        _questionsLoaded = true;
        _generatedQuestions =
            rawQuestions.map((q) {
              return Question(
                questionText: q['questionText'],
                options: List<String>.from(q['options']),
                correctAnswerIndex: q['correctAnswerIndex'] ?? 0,
              );
            }).toList();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load questions.')));
    }
  }

  // Function to remove a file from the list
  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF271D15), // Background color
      appBar: AppBar(
        backgroundColor: Color(0xFF271D15), // AppBar background
        title: Text(
          "Add Papers",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF4D582), // Text color for contrast
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructional text
            Text(
              "Access up to $_maxFiles sample papers for practice and preparation.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF4D582), // Lighter text for visibility
              ),
            ),
            SizedBox(height: 20),

            // Colored bar with icons
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF4D582),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Create New Folder Icon - Taps to pick files
                  IconButton(
                    icon: Icon(
                      Icons.create_new_folder,
                      color: Color(0xFF271D15),
                    ),
                    onPressed: _pickFiles, // When clicked, pick files
                  ),
                  // Folder Icon (This can be used for other purposes if needed)
                  Icon(Icons.folder, color: Color(0xFF271D15)),
                  // View List Icon (This can be used for listing files, etc.)
                  Icon(Icons.view_list, color: Color(0xFF271D15)),
                ],
              ),
            ),
            SizedBox(height: 10),

            // File upload section
            GestureDetector(
              onTap: _pickFiles,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(129, 244, 214, 130),
                  border: Border.all(color: Color(0xFFF4D582)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 40,
                        color: Color(0xFFF4D582),
                      ),
                      Text(
                        "Drag and drop files here or tap to upload",
                        style: TextStyle(color: Color(0xFFF4D582)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            // List of selected files
            Expanded(
              child: ListView.builder(
                itemCount: _files.length,
                itemBuilder:
                    (context, index) => Card(
                      color: Color(0xFFF4D582), // Light background for contrast
                      child: ListTile(
                        title: Text(
                          _files[index],
                          style: TextStyle(color: Color(0xFF271D15)),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeFile(index),
                        ),
                      ),
                    ),
              ),
            ),

            // Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: _processPapers, // Call API to generate questions
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF4D582),
                  ),
                  child: Text(
                    "Add",
                    style: TextStyle(color: Color(0xFF271D15)),
                  ),
                ),

                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _files.clear(); // Clear the list if cancel is pressed
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF4D582),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFF271D15)),
                  ),
                ),
              ],
            ),

            if (_isLoading)
              Center(
                child: CircularProgressIndicator(color: Color(0xFFF4D582)),
              ),

            if (_questionsLoaded)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "✅ Questions Loaded!",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            SizedBox(height: 150),

            // Next button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed:
                    _questionsLoaded
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => QuizScreen(
                                    questions: _generatedQuestions,
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF4D582),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Next", style: TextStyle(color: Color(0xFF271D15))),
                    Icon(Icons.arrow_forward, color: Color(0xFF271D15)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
