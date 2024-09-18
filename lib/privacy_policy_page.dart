import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:screenWidth * 0.06, vertical: screenWidth*0.0), // Adjust padding based on screen size
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button using an Image
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back when tapped
                    },
                    child: Image.asset(
                      'assets/arrow.png', // Your custom back arrow image path
                      width: screenWidth * 0.08, // Responsive width
                      height: screenHeight * 0.07, // Responsive height
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: screenHeight * 0.01), // Space after header

              // Main description text
              Center(
                child: Text(
                  'Love World values your privacy. This policy explains how we collect, use, and protect your data.',
                  style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.045, // Responsive text size
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenHeight * 0.023),

              // Section 1: Information We Collect
              _buildSectionTitle('1. Information We Collect', screenWidth),
              _buildBulletPoint('Usage Data: How you interact with the app.', screenWidth),
              _buildBulletPoint('Location Data: If you grant permission.', screenWidth),
              SizedBox(height: screenHeight * 0.03),

              // Section 2: How We Use Your Data
              _buildSectionTitle('2. How We Use Your Data', screenWidth),
              _buildBulletPoint('Legal Compliance: To meet legal obligations.', screenWidth),
              _buildBulletPoint('Communication: Send updates and notifications.', screenWidth),
              _buildBulletPoint('Service Delivery: To operate and improve the app.', screenWidth),
              SizedBox(height: screenHeight * 0.03),

              // Section 3: Data Sharing
              _buildSectionTitle('3. Data Sharing', screenWidth),
              _buildBulletPoint('Service Providers: We may share data with trusted partners.', screenWidth),
              SizedBox(height: screenHeight * 0.03),

              // Section 4: Contact Us
              _buildSectionTitle('4. Contact Us', screenWidth),
              _buildBulletPoint('Questions? Email us at privacy@loveworld.com.', screenWidth),
              SizedBox(height: screenHeight * 0.03),

              // Section 5: Security
              _buildSectionTitle('5. Security', screenWidth),
              _buildBulletPoint('Protection: We use encryption to safeguard your data.', screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build section title
  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontSize: screenWidth * 0.05, // Responsive font size
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper method to build bullet points
  Widget _buildBulletPoint(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: screenWidth * 0.03, color: Colors.blue), // Responsive bullet size
          SizedBox(width: screenWidth * 0.03), // Space between bullet and text
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.045, // Responsive text size
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
