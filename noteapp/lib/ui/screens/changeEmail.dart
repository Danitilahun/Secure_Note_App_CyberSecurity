import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:noteapp/data/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  TextEditingController _newEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _newEmailController,
              decoration: InputDecoration(
                labelText: 'New Email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Call the method to change the password
                String newEmail = _newEmailController.text;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int userId = prefs.getInt('userId') ?? 0;
                bool Changed = await helper.changeEmail(userId, newEmail);

                if (Changed) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? email = prefs.getString('email');

                  await _sendVerificationCode(
                      email!, "your email changed  to $newEmail successfully.");
                  Navigator.pushReplacementNamed(context, '/noteList');
                  await _sendVerificationCode(newEmail!,
                      "your email changed from $email to $newEmail successfully.");
                  prefs.setString('email', newEmail!);
                  Navigator.pushReplacementNamed(context, '/noteList');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            Text('Wrong old password or Invalid new password'),
                        content: Text(
                            'Check the correctness of your old password or Please choose a stronger password. The password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Change Email'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationCode(String email, String messageN) async {
    String username = 'tiledan2015@gmail.com'; // Update with your Gmail address
    String password = 'ahmzdwiuhfqcatwz'; // Update with your Gmail password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Secure Note App') // Update with your name
      ..recipients.add(email)
      ..subject = 'Verification Code'
      ..text = '$messageN';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.mail}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
