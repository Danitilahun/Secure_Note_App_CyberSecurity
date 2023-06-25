// import 'package:flutter/material.dart';
// import 'package:noteapp/data/dbhelper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'dart:math';

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
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
//                 _registerUser();
//               },
//               child: Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _registerUser() async {
//     String username = _usernameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
//       DbHelper dbHelper = DbHelper();
//       int? userId = await dbHelper.registerUser(username, email, password);

//       if (userId != null) {
//         String verificationCode = _generateVerificationCode();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('verificationCode', verificationCode);
//         await prefs.setInt('userId', userId);
//         await _sendVerificationCode(email, verificationCode);

//         Navigator.pushNamed(context, '/verification');
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Registration Failed'),
//               content: Text('Unable to register user.'),
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
//             content: Text('Please enter valid username, email, and password.'),
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

//   Future<void> _sendVerificationCode(
//       String email, String verificationCode) async {
//     String username = 'tiledan2015@gmail.com'; // Update with your Gmail address
//     String password = 'ahmzdwiuhfqcatwz'; // Update with your Gmail password

//     final smtpServer = gmail(username, password);

//     final message = Message()
//       ..from = Address(username, 'Secure Note App') // Update with your name
//       ..recipients.add(email)
//       ..subject = 'Verification Code'
//       ..text = 'Your verification code is: $verificationCode';

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ${sendReport.mail}');
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }

//   String _generateVerificationCode() {
//     // Generate a 4-digit verification code
//     return (1000 + Random().nextInt(9000)).toString();
//   }
// }

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
// import 'package:noteapp/data/dbhelper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   bool _showPassword = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: Text('Registration'),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.grey[900],
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 80,
//                 ),
//                 TextField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     labelStyle: TextStyle(color: Colors.white),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     hintStyle: TextStyle(color: Colors.white),
//                   ),
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 SizedBox(height: 16.0),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(color: Colors.white),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     hintStyle: TextStyle(color: Colors.white),
//                   ),
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 SizedBox(height: 16.0),
//                 TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: TextStyle(color: Colors.white),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                     hintStyle: TextStyle(color: Colors.white),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _showPassword ? Icons.visibility : Icons.visibility_off,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _showPassword = !_showPassword;
//                         });
//                       },
//                     ),
//                   ),
//                   obscureText: !_showPassword,
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _registerUser,
//                   child: Text('Register'),
//                   style: ElevatedButton.styleFrom(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//                     minimumSize: Size(double.infinity, 0),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "'Already have an account? ",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       // SizedBox(width: 5.0),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/login');
//                         },
//                         child: Text(
//                           'Login',
//                           style: TextStyle(
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _registerUser() async {
//     String username = _usernameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
//       DbHelper dbHelper = DbHelper();
//       int? userId = await dbHelper.registerUser(username, email, password);

//       if (userId != null) {
//         String verificationCode = _generateVerificationCode();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('verificationCode', verificationCode);
//         await prefs.setInt('userId', userId);
//         await _sendVerificationCode(email, verificationCode);

//         Navigator.pushNamed(context, '/verification');
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Registration Failed'),
//               content: Text('Unable to register user.'),
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
//             content: Text('Please enter valid username, email, and password.'),
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

//   Future<void> _sendVerificationCode(
//       String email, String verificationCode) async {
//     String username = 'tiledan2015@gmail.com'; // Update with your Gmail address
//     String password = 'ahmzdwiuhfqcatwz'; // Update with your Gmail password

//     final smtpServer = gmail(username, password);

//     final message = Message()
//       ..from = Address(username, 'Secure Note App') // Update with your name
//       ..recipients.add(email)
//       ..subject = 'Verification Code'
//       ..text = 'Your verification code is: $verificationCode';

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ${sendReport.mail}');
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }

//   String _generateVerificationCode() {
//     // Generate a 4-digit verification code
//     return (1000 + Random().nextInt(9000)).toString();
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:noteapp/data/dbhelper.dart';
import 'package:noteapp/models/insertResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _CshowPassword = false;
  String _passwordError = '';
  String _suggestedPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
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
                  onChanged: (value) {
                    String password = _passwordController.text.trim();

                    _checkPasswordStrength(password);
                  },
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
                TextField(
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    String confirmPassword =
                        _confirmPasswordController.text.trim();
                    _checkPasswordStrength(confirmPassword);
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                        _CshowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _CshowPassword = !_CshowPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_CshowPassword,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                if (_passwordError.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _passwordError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (_suggestedPassword.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Suggested Password: $_suggestedPassword',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
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
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
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
      ),
    );
  }

  void _registerUser() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password != confirmPassword) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text('Unable to register user.'),
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
      if (_checkPasswordStrength(password)) {
        DbHelper dbHelper = DbHelper();
        InsertResult? result =
            await dbHelper.registerUser(username, email, password);
        int? userId = result!.id;
        String ema_il = result.email;

        if (userId != null) {
          String verificationCode = _generateVerificationCode();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('verificationCode', verificationCode);
          await prefs.setInt('userId', userId);
          prefs.setString('email', ema_il);
          await _sendVerificationCode(email, verificationCode);

          Navigator.pushNamed(context, '/verification');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registration Failed'),
                content: Text('Unable to register user.'),
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
              title: Text('Invalid Password'),
              content: Text(
                  'Please choose a stronger password. The password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character.'),
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
            content: Text(
                'Please enter valid username, email, password, and confirm password.'),
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

  bool _checkPasswordStrength(String password) {
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      String error =
          'Please choose a stronger password. The password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
      setState(() {
        _passwordError = error;
        _suggestedPassword = _generateSuggestedPassword();
      });
      return false;
    } else {
      setState(() {
        _passwordError = '';
        _suggestedPassword = '';
      });
      return true;
    }
  }

  String _generateSuggestedPassword() {
    const String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String digits = '0123456789';
    const String specialCharacters = '!@#\$%^&*()-_+=[]{}|:;"<>,.?/~';

    String allCharacters =
        uppercaseLetters + lowercaseLetters + digits + specialCharacters;
    String password = '';

    for (int i = 0; i < 8; i++) {
      int randomIndex = Random().nextInt(allCharacters.length);
      password += allCharacters[randomIndex];
    }

    return password;
  }
}
