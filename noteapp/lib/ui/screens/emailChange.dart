import 'package:flutter/material.dart';
import 'package:noteapp/ui/screens/changeEmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailChange extends StatefulWidget {
  @override
  _EmailChangePageState createState() => _EmailChangePageState();
}

class _EmailChangePageState extends State<EmailChange> {
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.grey[900],
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _verificationCodeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintStyle: TextStyle(color: Colors.white),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 60.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _verifyCode();
                },
                child: Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCode() async {
    String verificationCode = _verificationCodeController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCode = prefs.getString('verificationCode');

    if (verificationCode == savedCode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangeEmailScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verification Failed'),
            content: Text('Invalid verification code.'),
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
  }
}
