import 'package:flutter/material.dart';

class PaperAnalyzerApp extends StatelessWidget {
  const PaperAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Paper Analyzer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centers the title in the AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'images/reading.jpeg',
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Add Your Paper section
                const SizedBox(height: 32),
                const Text(
                  "Add Your Paper",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Analyze and get accurate answers for your paper, whether it's an MCQ or essay based.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Form fields integrated inline
                const PaperInputForm(),
                
                const SizedBox(height: 60), // Add space at bottom for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show bottom sheet with paper creation options
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => _buildPaperCreationOptions(context),
          );
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Bottom sheet for paper creation options
  Widget _buildPaperCreationOptions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Create New Paper",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.create_outlined),
            title: const Text("Create from scratch"),
            subtitle: const Text("Build a new paper with AI assistance"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to the create from scratch screen
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const CreatePaperScreen())
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text("Upload existing paper"),
            subtitle: const Text("Get AI analysis for your paper"),
            onTap: () {
              Navigator.pop(context);
              // Show file picker or upload screen
              _showUploadOptions(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Browse templates"),
            subtitle: const Text("Start with paper templates"),
            onTap: () {
              Navigator.pop(context);
              // Navigate to templates gallery
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const TemplateGalleryScreen())
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Dialog for upload options
  void _showUploadOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Upload Paper"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Upload from gallery"),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a photo"),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_copy),
              title: const Text("Choose document"),
              onTap: () {
                Navigator.pop(context);
                // Implement file picker
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}

class PaperInputForm extends StatefulWidget {
  const PaperInputForm({super.key});

  @override
  _PaperInputFormState createState() => _PaperInputFormState();
}

class _PaperInputFormState extends State<PaperInputForm> {
  final TextEditingController _titleController = TextEditingController();
  String? paperType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Paper Title Field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Paper Title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Paper Type Dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Paper Type",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: ["MCQ", "Essay"].map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (val) => setState(() => paperType = val),
          ),
          const SizedBox(height: 24),
          
          // Upload Paper Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F5DC), // Beige color
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Upload Paper",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// New screens to support the FAB functionality

class CreatePaperScreen extends StatelessWidget {
  const CreatePaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Paper"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create your paper with AI assistance",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Paper details form would go here
            TextField(
              decoration: InputDecoration(
                labelText: "Paper Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Paper Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ["MCQ", "Essay"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Subject/Topic",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Difficulty Level",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ["Easy", "Medium", "Hard"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (val) {},
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Generate Paper with AI"),
            ),
          ],
        ),
      ),
    );
  }
}

class TemplateGalleryScreen extends StatelessWidget {
  const TemplateGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paper Templates"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6, // Just showing 6 template examples
        itemBuilder: (context, index) {
          List<String> templateTypes = [
            "Physics MCQ",
            "History Essay",
            "Math Problem Set",
            "Chemistry MCQ",
            "English Essay",
            "Biology Quiz"
          ];
          
          return GestureDetector(
            onTap: () {
              // Handle template selection
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.description,
                        size: 40,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          templateTypes[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Standard template",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}