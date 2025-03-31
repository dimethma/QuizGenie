import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddPapersPage extends StatefulWidget {
  @override
  _AddPapersPageState createState() => _AddPapersPageState();
}

class _AddPapersPageState extends State<AddPapersPage> {
  List<String> _files = []; // List to store selected file paths
  final int _maxFiles = 5; // Maximum number of files allowed

  // Function to pick files using FilePicker
  void _pickFiles() async {
    if (_files.length >= _maxFiles) return;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
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
                  Icon(Icons.create_new_folder, color: Color(0xFF271D15)),
                  Icon(Icons.folder, color: Color(0xFF271D15)),
                  Icon(Icons.view_list, color: Color(0xFF271D15)),
                  Icon(Icons.account_tree, color: Color(0xFF271D15)),
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
                  onPressed: _pickFiles,
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
                  onPressed: () {},
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

            SizedBox(height: 150),

            // Next button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
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
