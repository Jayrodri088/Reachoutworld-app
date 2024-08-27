import 'package:flutter/material.dart';
import 'enter_new_password_screen.dart'; // Import the Enter New Password Screen

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.04), // Adjust height dynamically
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle password recovery
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterNewPasswordScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(
                              double.infinity,
                              screenHeight *
                                  0.07), // Adjust button height dynamically
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.black,
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
