// import 'package:flutter/material.dart';
// import 'package:noteapp/data/dbhelper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 _loginUser();
//               },
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _loginUser() async {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (email.isNotEmpty && password.isNotEmpty) {
//       DbHelper dbHelper = DbHelper();
//       int? userId = await dbHelper.loginUser(email, password);

//       if (userId != null) {
//         // Save the user ID to shared preferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setInt('userId', userId);

//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Login Successful'),
//               content: Text('User logged in successfully!'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     // Navigate to the home page
//                     Navigator.pushReplacementNamed(context, '/noteList');
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Login Failed'),
//               content: Text('Invalid email or password.'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Invalid Input'),
//             content: Text('Please enter valid email and password.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noteapp/data/dbhelper.dart';
import 'package:noteapp/models/insertResult.dart';
import 'package:noteapp/ui/screens/varify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _loginUser,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "'Already have an account? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(width: 5.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      DbHelper dbHelper = DbHelper();
      InsertResult? result = await dbHelper.loginUser(email, password);
      print(result);
      if (result != null && result.id != null) {
        int userId = result.id!;
        String verificationCode = _generateVerificationCode();
        await _sendVerificationCode(email, verificationCode);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('userId', userId);
        prefs.setString('verificationCode', verificationCode);
        prefs.setString('email', result.email);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter a valid email and password.'),
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
