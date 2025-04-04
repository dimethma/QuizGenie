import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                  child: const Text("OK"),
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
      'http://172.20.10.4:5000/analyze-topics',
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
      appBar: AppBar(
        title: const Text("Topic Breakdown Analyzer"),
        backgroundColor: const Color(0xFF6A5200),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
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
        backgroundColor: const Color(0xFFD28A56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
