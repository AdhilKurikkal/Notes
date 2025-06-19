import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/view/add_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    laodNotes();
  }

  //laod note

  Future<void> laodNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = prefs.getStringList('notes') ?? [];

    setState(() {
      notes =
          notesData
              .map((noteString) => Note.fromJson(jsonDecode(noteString)))
              .toList();
    });
  }

  //save note

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = notes.map((note) => json.encode(note.toJson())).toList();
    await prefs.setStringList('notes', notesData);
  }

  void addNote(Note note) {
    setState(() {
      notes.add(note);
    });
    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Notes')),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child:
                  notes.isEmpty
                      ? const Center(child: Text('No notes yet.'))
                      : ListView.builder(
                        itemBuilder: (context, index) {
                          return CupertinoListTile(
                            title: Text(notes[index].title),
                            subtitle: Text(notes[index].description),
                          );
                        },
                        itemCount: notes.length,
                      ),
            ),

            CupertinoButton.filled(
              child: const Text('Add Note'),
              onPressed: () async {
                final newNote = await Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => AddNoteScreen()),
                );
                if (newNote != null && newNote is Note) {
                  addNote(newNote);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
