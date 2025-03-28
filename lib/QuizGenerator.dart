import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookManagement extends StatefulWidget {
  const BookManagement({super.key});

  @override
  State<BookManagement> createState() => _BookManagementState();
}

class _BookManagementState extends State<BookManagement> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addItem() async {
    if (_controller.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('Book').add({
        'name': _controller.text,
      });
      _controller.clear();
    }
  }

  Future<void> _updateItem(String id, String currentName) async {
    TextEditingController updateController = TextEditingController(
      text: currentName,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Update a book"),
            content: TextField(
              controller: updateController,
              decoration: InputDecoration(
                labelText: "New name for: $currentName",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('Book')
                      .doc(id)
                      .update({'name': updateController.text});
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('Book').doc(id).delete();
  }

  Stream<QuerySnapshot> _getItems() {
    return FirebaseFirestore.instance.collection('Book').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Management System")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter a book name",
                suffixIcon: IconButton(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add, color: Colors.green),
                ),
              ),
            ),
          ),
          _bookList(),
        ],
      ),
    );
  }

  _bookList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text("All Books", style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getItems(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var docs = snapshot.data!.docs;
                  return ListView(
                    children:
                        docs.map((doc) {
                          return ListTile(
                            title: Text(doc['name']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.lightBlue,
                                  ),
                                  onPressed:
                                      () => _updateItem(doc.id, doc['name']),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteItem(doc.id),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
