// import 'package:flutter/material.dart';
// import 'package:noteapp/data/dbhelper.dart';
// import 'package:noteapp/models/note_model.dart';
// import 'package:noteapp/ui/screens/create_or_edit.dart';

// class NoteList extends StatefulWidget {
//   const NoteList({Key? key}) : super(key: key);

//   @override
//   State<NoteList> createState() => _NoteListState();
// }

// class _NoteListState extends State<NoteList> {
//   DbHelper helper = DbHelper();
//   List<Note>? notes;

//   @override
//   void initState() {
//     super.initState();
//     showData();
//   }

//   Future<void> showData() async {
//     await helper.openDb();

//     final retrievedNotes = await helper.getLists();

//     setState(() {
//       notes = retrievedNotes;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text("Notes List"),
//       ),
//       body: ListView.builder(
//         itemCount: notes?.length ?? 0,
//         itemBuilder: (BuildContext context, int index) {
//           return Dismissible(
//             key: Key(notes![index].title!),
//             onDismissed: (direction) async {
//               String strName = notes![index].title!;
//               await helper.deleteList(notes![index]);
//               setState(() {
//                 notes?.removeAt(index);
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("$strName deleted")),
//               );
//             },
//             child: ListTile(
//               title: Text(notes![index].title!),
//               leading: CircleAvatar(
//                 child: Text(notes![index].title![0]),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NewItemScreen(
//                       note: notes![index],
//                       isNew: false,
//                     ),
//                   ),
//                 );
//               },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NewItemScreen(
//                             note: notes![index],
//                             isNew: false,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () async {
//                       String strName = notes![index].title!;
//                       await helper.deleteList(notes![index]);
//                       setState(() {
//                         notes?.removeAt(index);
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("$strName deleted")),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NewItemScreen(
//                 note: Note(0, '', ""),
//                 isNew: true,
//               ),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:noteapp/data/dbhelper.dart';
import 'package:noteapp/data/notify.dart';
import 'package:noteapp/models/note_model.dart';
import 'package:noteapp/ui/screens/changeEmail.dart';
import 'package:noteapp/ui/screens/changePassword.dart';
import 'package:noteapp/ui/screens/create_or_edit.dart';
import 'package:noteapp/ui/screens/emailChange.dart';
import 'package:noteapp/ui/widgets/note_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DbHelper helper = DbHelper();
  List<Note>? notes;
  List<Color> colors = [
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();

    showData();
  }

  Future<void> showData() async {
    await helper.openDb();

    // Get the userId from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    print("i" + userId.toString());

    if (helper.db != null) {
      print("avba");
      final retrievedNotes = await helper.getLists(userId: userId);
      setState(() {
        notes = retrievedNotes;
      });
    }
  }

  Color getRandomColor() {
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    // showData();
    final NotificationService notificationService =
        NotificationService(context);
    void _scheduleNotificationAfterDelay() async {
      await Future.delayed(Duration(seconds: 30)); // Delay of 30 seconds
      notificationService.showNotification(
        title: 'password change reminder',
        body:
            'It has been a log since you chaged the password. Change your password please.',
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Notes List"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Note App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Change Email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? email = prefs.getString('email');
                String verificationCode = _generateVerificationCode();
                await prefs.setString('verificationCode', verificationCode);
                await _sendVerificationCode(email!, verificationCode);
                // Handle change username
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailChange()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Handle change password
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                // Handle logout
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userId');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false, // Remove all existing routes from the stack
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: notes?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final note = notes![index];
            final color = getRandomColor();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dismissible(
                key: Key(note.title!),
                onDismissed: (direction) async {
                  String strName = note.title!;
                  await helper.deleteList(note);
                  setState(() {
                    notes?.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$strName deleted")),
                  );
                },
                child: NoteListItem(
                  note: note,
                  color: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewItemScreen(
                          note: note,
                          isNew: false,
                        ),
                      ),
                    );
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewItemScreen(
                          note: note,
                          isNew: false,
                        ),
                      ),
                    );
                  },
                  onDelete: () async {
                    String strName = note.title!;
                    await helper.deleteList(note);
                    setState(() {
                      notes?.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$strName deleted")),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewItemScreen(
                  note: Note(id: 0, title: "", content: "", userId: 0),
                  isNew: true,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Future<void> _sendVerificationCode(
      String email, String verificationCode) async {
    String username = 'tiledan2015@gmail.com'; // Update with your Gmail address
    String password = 'ahmzdwiuhfqcatwz'; // Update with your Gmail password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Secure Note App') // Update with your name
      ..recipients.add(email)
      ..subject = 'Verification Code'
      ..text = 'Your verification code is: $verificationCode';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.mail}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  String _generateVerificationCode() {
    // Generate a 4-digit verification code
    return (1000 + Random().nextInt(9000)).toString();
  }
}
