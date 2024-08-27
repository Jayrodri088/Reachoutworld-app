import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'sign_in.dart';
import 'sign_up.dart';
import 'welcome_screen.dart';
import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/signin': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/dashboard': (context) => const DashboardScreen(
              userName: 'Jane Doe', // Replace with dynamic username
              userCountry:
                  'Lagos, Nigeria', // Replace with dynamic user country
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);

    _controller!.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6, // Adjusts the logo size relative to screen width
          child: AspectRatio(
            aspectRatio: 1, // Maintains the aspect ratio of the logo
            child: Image.asset(
              'assets/ROW_1_logo.png', // Replace with your logo path
              fit: BoxFit.contain, // Ensures the image fits within the bounds
            ),
          ),
        ),
      ),
    );
  }
}
