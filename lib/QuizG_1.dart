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
      appBar: AppBar(title: Text("Add Papers")), // App bar with title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructional text
            Text(
              "Access up to $_maxFiles sample papers for practice and preparation.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ), // Increased space between text and blue color bar
            // Blue color bar with rounded corners
            Container(
              height: 50, // Set height of the blue bar to 50
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  10,
                ), // Rounded corners for the blue bar
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Create new folder icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.25,
                      ), // Semi-transparent background
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners for icons
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding
                      icon: Icon(
                        Icons.create_new_folder,
                        color: Colors.white,
                        size: 20, // Icon size
                      ),
                      onPressed: () {},
                    ),
                  ),
                  // Display folders icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners for icons
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding
                      icon: Icon(
                        Icons.folder,
                        color: Colors.white,
                        size: 20,
                      ), // Icon size
                      onPressed: () {},
                    ),
                  ),
                  // Display list view icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners for icons
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding
                      icon: Icon(
                        Icons.view_list,
                        color: Colors.white,
                        size: 20, // Icon size
                      ),
                      onPressed: () {},
                    ),
                  ),
                  // Display tree view icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners for icons
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding
                      icon: Icon(
                        Icons.account_tree,
                        color: Colors.white,
                        size: 20, // Icon size
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Drag-and-drop file upload area
            GestureDetector(
              onTap: _pickFiles,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 40,
                        color: Colors.blue,
                      ), // Upload icon
                      Text(
                        "Drag and drop files here or tap to upload",
                      ), // Instruction text
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
                    (context, index) => ListTile(
                      title: Text(_files[index]), // File name
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ), // Delete file button
                        onPressed: () => _removeFile(index),
                      ),
                    ),
              ),
            ),

            // Row containing Add and Cancel buttons aligned to the left
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _pickFiles,
                  child: Text("Add"),
                ), // Add button
                SizedBox(width: 10), // Space between buttons
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Cancel"),
                ), // Cancel button
              ],
            ),
            SizedBox(height: 200),

            // Next button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Next"), Icon(Icons.arrow_forward)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
