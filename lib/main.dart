import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_app/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CupertinoNotesApp());
}

class CupertinoNotesApp extends StatelessWidget {
  const CupertinoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
