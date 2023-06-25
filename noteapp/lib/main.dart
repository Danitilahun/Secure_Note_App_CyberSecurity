import 'package:flutter/material.dart';
import 'package:noteapp/data/dbhelper.dart';
import 'package:noteapp/ui/screens/login_page.dart';
import 'package:noteapp/ui/screens/noteList.dart';
import 'package:noteapp/ui/screens/registration_page.dart';
import 'package:noteapp/ui/screens/varify.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  DbHelper dbHelper = DbHelper();
  await dbHelper.openDb();

  // Get the userId from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userId');

  // Determine the initial route based on the userId
  String initialRoute = (userId != null) ? '/noteList' : '/';

  runApp(NoteApp(initialRoute: initialRoute));
}

class NoteApp extends StatelessWidget {
  final String initialRoute;

  const NoteApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(),
        '/noteList': (context) => NoteList(),
        '/verification': (context) => VerificationPage(),
      },
    );
  }
}
