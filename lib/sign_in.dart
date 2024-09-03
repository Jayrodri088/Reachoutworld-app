import 'dart:async';  // Import the Timer class
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'api/sign_in_api_service.dart';
import 'api/recent_activities_api_service.dart';
import 'dashboard.dart';
import 'password_recovery_screen.dart';
import 'dart:io';

// Global variable to store recent activities
List<Map<String, dynamic>> recentActivities = [];

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
  Timer? _timer; // Declare the timer

  final SignInApiService signInApiService = SignInApiService();
  final RecentActivitiesApiService recentActivitiesApiService = RecentActivitiesApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final response = await signInApiService.signInUser(email, password);

        setState(() {
          _isLoading = false;
        });

        if (response['status'] == 'success') {
          final String userId = response['user_id'].toString();

          // Fetch recent activities and store them in the global variable
          recentActivities = await recentActivitiesApiService.getRecentActivities(userId);

          // Start a timer to fetch recent activities every 2 minutes
          _startFetchingRecentActivities(userId);

          // Navigate to the DashboardScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userId: userId),
            ),
          );
        } else {
          _showAlertDialog(response['message'] ?? 'Login failed');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showAlertDialog('Wrong email or password');
      }
    }
  }

  void _startFetchingRecentActivities(String userId) {
    print('Starting periodic fetch for recent activities...');

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      try {
        print('Fetching recent activities...');
        List<Map<String, dynamic>> fetchedActivities = await recentActivitiesApiService.getRecentActivities(userId);

        if (fetchedActivities.isNotEmpty) {
          setState(() {
            recentActivities = fetchedActivities;
          });
          print('Recent activities updated: $recentActivities');
        } else {
          print('No new activities found.');
        }
      } catch (e) {
        print('Error fetching recent activities: $e');
      }
    });
  }

  void _showAlertDialog(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Login Failed'),
            content: Text('Wrong email or password'),
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
                  Navigator.of(context).pop();
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
                SizedBox(height: screenHeight * 0.1),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Hi! Welcome back',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
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
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                SizedBox(height: screenHeight * 0.01),
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
                SizedBox(height: screenHeight * 0.02),
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
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: screenWidth * 0.15,
                        endIndent: screenWidth * 0.02,
                      ),
                    ),
                    Text(
                      'Or Sign in with',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: screenWidth * 0.02,
                        endIndent: screenWidth * 0.15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
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
                        horizontal: screenWidth * 0.05),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/app_logo.png',
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Kings Chat',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: screenWidth * 0.04,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
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
