import 'package:flutter/material.dart';
import 'package:noteapp/data/dbhelper.dart';
import 'package:noteapp/models/note_model.dart';
import 'package:noteapp/ui/screens/noteList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewItemScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const NewItemScreen({required this.note, required this.isNew});

  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final title = TextEditingController();
  final content = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();
    if (!widget.isNew) {
      title.text = widget.note.title!;
      content.text = widget.note.content!;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text((widget.isNew) ? 'New note' : 'Edit note'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: title,
              style: const TextStyle(color: Colors.white, fontSize: 30),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: content,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: null,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type something here',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )), // Allow multiple lines for priority input
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.note.title = title.text;
          widget.note.content = content.text;

          // print("askfnsdmdvbkdjghvkmcvnbjdfhvnhvn");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int userId = prefs.getInt('userId') ?? 0;
          // print(userId);
          // Retrieve the user ID from shared preferences

          if (widget.isNew) {
            if (userId != null) {
              print(userId);
              widget.note.userId = userId; // Set the user ID for the note
              helper.insertList(widget.note, userId!);
            } else {
              // print("here" + userId.toString());
            }
          } else {
            helper.updateList(widget.note);
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteList()),
          );
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }
}
