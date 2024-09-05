import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VerificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController1 = TextEditingController();
  final TextEditingController _codeController2 = TextEditingController();
  final TextEditingController _codeController3 = TextEditingController();
  final TextEditingController _codeController4 = TextEditingController();

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;

  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();

    _focusNode1.addListener(() {
      setState(() {});
    });
    _focusNode2.addListener(() {
      setState(() {});
    });
    _focusNode3.addListener(() {
      setState(() {});
    });
    _focusNode4.addListener(() {
      setState(() {});
    });

    _startTimer();
  }

  @override
  void dispose() {
    _codeController1.dispose();
    _codeController2.dispose();
    _codeController3.dispose();
    _codeController4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _start = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/arrow.png', // Replace with your image path
                      width: screenWidth * 0.07, // Adjust width dynamically
                      height: screenWidth * 0.07, // Adjust height dynamically
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Verification Code',
                  style: TextStyle(
                    fontSize:
                        screenWidth * 0.06, // Adjust font size dynamically
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'We have sent the verification code to your email address',
                  style: TextStyle(
                      fontSize:
                          screenWidth * 0.04), // Adjust font size dynamically
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCodeField(_codeController1, _focusNode1, _focusNode2,
                        screenWidth),
                    _buildCodeField(_codeController2, _focusNode2, _focusNode3,
                        screenWidth),
                    _buildCodeField(_codeController3, _focusNode3, _focusNode4,
                        screenWidth),
                    _buildCodeField(
                        _codeController4, _focusNode4, null, screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text(
                  "I didn't receive Code",
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: _canResend
                      ? () {
                          _startTimer();
                          // Handle resend code action
                        }
                      : null,
                  child: Text(
                    _canResend
                        ? 'Resend Code'
                        : 'Resend Code 00:${_start.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Color.fromARGB(255, 32, 55, 187),),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
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
                              0.07), // Adjust button height dynamically
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth *
                              0.04), // Adjust font size dynamically
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(TextEditingController controller,
      FocusNode currentNode, FocusNode? nextNode, double screenWidth) {
    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.15,
      child: TextFormField(
        controller: controller,
        focusNode: currentNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: screenWidth * 0.07), // Adjust font size dynamically
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        onChanged: (value) {
          if (value.isNotEmpty) {
            _nextField(value: value, focusNode: nextNode ?? currentNode);
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: currentNode.hasFocus ? Color.fromARGB(255, 32, 55, 187) : Colors.red,
              width: currentNode.hasFocus ? 2.0 : 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
