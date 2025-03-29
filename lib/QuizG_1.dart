import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPapersPage extends StatefulWidget {
  @override
  _AddPapersPageState createState() => _AddPapersPageState();
}

class _AddPapersPageState extends State<AddPapersPage> {
  List<String> _selectedFiles = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickFiles() async {
    if (_selectedFiles.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only add up to 5 sample papers.')),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files.map((file) => file.name));
        if (_selectedFiles.length > 5) {
          _selectedFiles = _selectedFiles.sublist(0, 5);
        }
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _saveToFirestore() async {
    if (_selectedFiles.isNotEmpty) {
      await _firestore.collection('sample_papers').add({
        'papers': _selectedFiles,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Papers saved successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Papers')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Papers',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Access up to 5 sample papers for practice and preparation.'),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.create_new_folder),
                  onPressed: () {},
                ),
                IconButton(icon: Icon(Icons.folder), onPressed: () {}),
                IconButton(icon: Icon(Icons.list), onPressed: () {}),
                IconButton(icon: Icon(Icons.account_tree), onPressed: () {}),
              ],
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickFiles,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 40, color: Colors.blue),
                      Text('Drag and drop files here to add them'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.insert_drive_file),
                    title: Text(_selectedFiles[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFile(index),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: _saveToFirestore, child: Text('Add')),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilePicker {
  static var platform;
}

class FilePickerResult {
  get files => null;
}
