import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isSignInHovered = false;
  bool _isSignUpHovered = false;

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Onboard_bg2.png', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(
                  height: screenHeight * 0.17), // Adjust height dynamically
              const Spacer(),
              Image.asset(
                'assets/ROW_1_logo.png', // Replace with your logo image path
                width: screenWidth * 0.7, // Adjust width dynamically
                height: screenWidth * 0.7, // Keep height proportional to width
              ),
              SizedBox(
                  height: screenHeight * 0.08), // Adjust height dynamically
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * 0.1), // Adjust padding dynamically
                child: Column(
                  children: [
                    Text(
                      ' Reach Out World Day',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.06, // Adjust font size dynamically
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ' Data Capture App',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.06, // Adjust font size dynamically
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.01), // Adjust height dynamically
                    Text(
                      'Sign up to start capturing data and',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.04, // Adjust font size dynamically
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'moments on the road to the grand ',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.04, // Adjust font size dynamically
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Reach Out World Day!',
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.04, // Adjust font size dynamically
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.03), // Adjust height dynamically
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isSignInHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isSignInHovered = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight *
                                  0.02), // Adjust padding dynamically
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight *
                                  0.01), // Adjust margin dynamically
                          decoration: BoxDecoration(
                            color: _isSignInHovered
                                ? Color.fromARGB(255, 32, 55, 187)
                                : Color.fromARGB(255, 32, 55, 187),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color.fromARGB(255, 32, 55, 187),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: _isSignInHovered
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: screenWidth *
                                    0.04, // Adjust font size dynamically
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isSignUpHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isSignUpHovered = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight *
                                  0.02), // Adjust padding dynamically
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight *
                                  0.01), // Adjust margin dynamically
                          decoration: BoxDecoration(
                            color: _isSignUpHovered
                                ? Color.fromARGB(255, 32, 55, 187)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color.fromARGB(255, 32, 55, 187),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: _isSignUpHovered
                                    ? Colors.black
                                    : Color.fromARGB(255, 32, 55, 187),
                                fontSize: screenWidth *
                                    0.04, // Adjust font size dynamically
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.02), // Adjust height dynamically
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text(
                        '',
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 55, 187),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
