import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String selectedExperience = ""; // Store the selected experience

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/arrow.png', // Your custom arrow image
            width: screenWidth * 0.089,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Feedback",
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Revert to original text color if changed
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Original background color
        elevation: 0, // Keep elevation as it was initially
      ),
      body: SafeArea(
        
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.052),
          child: SingleChildScrollView(
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "How was your Experience with our Product?",
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Text(
                    "Every Feedback matters to us.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey, // Original text color
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "Rate Your Experience",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEmojiOption('Excellent', 'assets/icon/excellent.png', screenWidth),
                    _buildEmojiOption('Awful', 'assets/icon/awful.png', screenWidth),
                    _buildEmojiOption('Poor', 'assets/icon/poor.png', screenWidth),
                    _buildEmojiOption('Neutral', 'assets/icon/neutral.png', screenWidth),
                    _buildEmojiOption('Fun', 'assets/icon/fun.png', screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "Which Problem did you experience while using our Product? How can we make it better?",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  maxLines: 8,
                  style: TextStyle(fontSize: screenWidth * 0.036, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Share Your Experience.....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle feedback submission
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A73E8),
                      minimumSize: Size(double.infinity, screenHeight * 0.01), // Adjust button height dynamically
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1, vertical: screenHeight * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Send Feedback",
                      style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
              
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiOption(String label, String assetPath, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExperience = label;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: selectedExperience == label ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Image.asset(
              assetPath,
              width: screenWidth * 0.12,
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: selectedExperience == label ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
