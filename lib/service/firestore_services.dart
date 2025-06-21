import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/model/note.dart';

class FirestoreServices {
  final _note = FirebaseFirestore.instance.collection('notes');

  //add
  Future<void> addNote(Note note) async {
    await _note.add(note.toJson());
  }

  //get
  Stream<List<Note>> getNotes() {
    return _note.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    });
  }

  //delete
  Future<void> deleteNote(Note note) async {
    final snapshot =
        await _note
            .where('title', isEqualTo: note.title)
            .where('description', isEqualTo: note.description)
            .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  //update

  Future<void> updateNote(Note oldNote, Note newNote) async {
    final snapshot =
        await _note
            .where('title', isEqualTo: oldNote.title)
            .where('description', isEqualTo: oldNote.description)
            .get();

    for (final doc in snapshot.docs) {
      await doc.reference.update(newNote.toJson());
    }
  }
}
