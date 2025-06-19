import 'package:flutter/cupertino.dart';
import 'package:notes_app/view/home.dart';

void main() {
  runApp(const CupertinoNotesApp());
}

class CupertinoNotesApp extends StatelessWidget {
  const CupertinoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
