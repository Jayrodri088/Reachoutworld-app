import 'dart:convert'; // For encoding and decoding JSON
import 'dart:io'; // For checking the platform
import 'package:flutter/cupertino.dart'; // For CupertinoAlertDialog
import 'package:flutter/material.dart'; // For AlertDialog and other widgets
import 'package:http/http.dart' as http;  // Import to check the platform
// import 'enter_new_password_screen.dart';
import 'sign_in.dart'; // Import your login screen

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

Future<void> _recoverPassword() async {
  setState(() {
    _isLoading = true;
  });

  final email = _emailController.text.trim();
  const url = 'http://apps.qubators.biz/reachoutworlddc/forgot_password.php';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    final responseData = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['status'] == 'success') {
      _showAlertDialog(
        title: 'Success',
        message: 'We have sent you an email. Please check your inbox.',
        buttonText: 'Login',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      );
    } else {
      _showAlertDialog(
        title: 'User Not Found',
        message: responseData['message'] ?? 'No account found with that email address.',
        buttonText: 'OK',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }
  } catch (e) {
    print('Error during password recovery: $e');
    _showAlertDialog(
      title: 'Error',
      message: 'Failed to send recovery email. Please try again later.',
      buttonText: 'OK',
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  void _showAlertDialog({required String title, required String message, required String buttonText, required VoidCallback onPressed}) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background container
          Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color.fromARGB(242, 250, 249, 247), // Background color
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: screenHeight * 0.05,
            ), // Adjust padding dynamically
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height:
                            screenHeight * 0.13), // Adjust height dynamically
                    Text(
                      'Password Recovery',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.06, // Adjust font size dynamically
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.01), // Adjust height dynamically
                    Text(
                      'Enter your registered email address to recover your account',
                      style: TextStyle(
                          fontSize: screenWidth *
                              0.04), // Adjust font size dynamically
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.04), // Adjust height dynamically
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.04), // Adjust height dynamically
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _recoverPassword();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 32, 55, 187),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(
                              double.infinity,
                              screenHeight *
                                  0.05), // Adjust button height dynamically
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth *
                                      0.04, // Adjust font size dynamically
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.02,
            child: IconButton(
              icon: Image.asset(
                'assets/arrow.png', // Replace with your image path
                width: screenWidth * 0.09, // Adjust width dynamically
                height: screenWidth * 0.09, // Adjust height dynamically
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
