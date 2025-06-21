// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/service/firestore_services.dart';
import 'package:notes_app/view/add_note.dart';
import 'package:notes_app/view/edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //initailize shared preferences
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

  final firestore = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Notes')),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: firestore.getNotes(),
                builder: (context, snapshot) {
                  // Handle connection state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  // Handle errors
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Handle empty state
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notes yet',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    );
                  }
                  final notes = snapshot.data!;
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Dismissible(
                        key: ValueKey(note.title), // use unique key
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: CupertinoColors.systemRed,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            CupertinoIcons.delete,
                            color: CupertinoColors.white,
                          ),
                        ),
                        onDismissed: (_) async {
                          await firestore.deleteNote(note);
                        },
                        child: CupertinoListTile(
                          title: Text(note.title),
                          subtitle: Text(note.description),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => EditNoteScreen(note: note),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
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
                  firestore.addNote(newNote);
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
