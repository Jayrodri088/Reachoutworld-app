import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'api/sign_in_api_service.dart'; // Import the SignInApiService
import 'dashboard.dart'; // Import the Dashboard Page
import 'password_recovery_screen.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLoading = false;

  final SignInApiService apiService = SignInApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Ensure inputs are properly trimmed
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Call the API service to sign in the user
        final response = await apiService.signInUser(email, password);

        setState(() {
          _isLoading = false;
        });

        if (response['status'] == 'success') {
          // Successfully signed in, navigate to the DashboardScreen
          final String userId = response['user_id'].toString();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                userId: userId, // Pass the userId to the dashboard
              ),
            ),
          );
        } else {
          // Handle invalid credentials or other issues
          _showAlertDialog(response['message'] ?? 'Login failed');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Display an error message for failed sign-in attempts
        _showAlertDialog('Failed to sign in. Error: $e');
      }
    }
  }

  void _showAlertDialog(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Login Failed'),
            content: Text(message),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
            title: const Text('Login Failed'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: screenHeight * 0.1), // Adjust height dynamically
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize:
                        screenWidth * 0.06, // Adjust font size dynamically
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.01), // Adjust height dynamically
                Text(
                  'Hi! Welcome back',
                  style: TextStyle(
                      fontSize:
                          screenWidth * 0.04), // Adjust font size dynamically
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height: screenHeight * 0.04), // Adjust height dynamically
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
                    height: screenHeight * 0.02), // Adjust height dynamically
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                    height: screenHeight * 0.01), // Adjust height dynamically
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordRecoveryScreen()),
                      );
                    },
                    child: const Text(
                      'Forgotten Password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.02), // Adjust height dynamically
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                    height: screenHeight * 0.03), // Adjust height dynamically
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: screenWidth * 0.15, // Adjust indent dynamically
                        endIndent:
                            screenWidth * 0.02, // Adjust end indent dynamically
                      ),
                    ),
                    Text(
                      'Or Sign in with',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.04, // Adjust font size dynamically
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: screenWidth * 0.02, // Adjust indent dynamically
                        endIndent:
                            screenWidth * 0.15, // Adjust end indent dynamically
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: screenHeight * 0.02), // Adjust height dynamically
                GestureDetector(
                  onTap: () {
                    // Handle KingsChat login
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal:
                            screenWidth * 0.05), // Adjust padding dynamically
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/app_logo.png', // Replace with your KingsChat logo path
                          width: screenWidth * 0.08, // Adjust width dynamically
                          height:
                              screenWidth * 0.08, // Adjust height dynamically
                        ),
                        SizedBox(
                            width:
                                screenWidth * 0.03), // Adjust width dynamically
                        Text(
                          'Kings Chat',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: screenWidth *
                                0.04, // Adjust font size dynamically
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.03), // Adjust height dynamically
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          screenWidth * 0.04, // Adjust font size dynamically
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: screenWidth *
                              0.04, // Adjust font size dynamically
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to sign up page
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
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
}
