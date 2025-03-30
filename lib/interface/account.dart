import 'package:flutter/material.dart';

class PaperAnalyzerApp extends StatelessWidget {
  const PaperAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paper Analyzer")),
      body: const Center(child: Text("List of Papers will be displayed here")),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPaperScreen()),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddPaperScreen extends StatefulWidget {
  const AddPaperScreen({super.key});

  @override
  _AddPaperScreenState createState() => _AddPaperScreenState();
}

class _AddPaperScreenState extends State<AddPaperScreen> {
  final TextEditingController _titleController = TextEditingController();
  String? paperType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Paper")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Paper Title"),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Paper Type"),
              items:
                  ["MCQ", "Essay"].map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
              onChanged: (val) => setState(() => paperType = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text("Upload Paper")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text("Save Paper")),
          ],
        ),
      ),
    );
  }
}
