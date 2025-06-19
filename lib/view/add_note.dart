import 'package:flutter/cupertino.dart';
import '../model/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void saveNote() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              title: const Text("Error"),
              content: const Text("Please enter both title and description."),
              actions: [
                CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
      return;
    }

    final note = Note(
      title: titleController.text,
      description: descriptionController.text,
    );

    Navigator.pop(context, note);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Add Note')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CupertinoTextField(
                controller: titleController,
                placeholder: 'Title',
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: descriptionController,
                placeholder: 'Description',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: saveNote,
                child: const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
