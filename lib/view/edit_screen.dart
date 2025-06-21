import 'package:flutter/cupertino.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/service/firestore_services.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.note.title);
    descCtrl = TextEditingController(text: widget.note.description);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Edit Note'),
        trailing: GestureDetector(
          onTap: () {
            final updatedNote = Note(
              title: titleCtrl.text,
              description: descCtrl.text,
            );
            FirestoreServices().updateNote(widget.note, updatedNote);
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.check_mark),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CupertinoTextField(controller: titleCtrl, placeholder: "Title"),
            SizedBox(height: 12),
            CupertinoTextField(
              controller: descCtrl,
              placeholder: "Description",
            ),
          ],
        ),
      ),
    );
  }
}
