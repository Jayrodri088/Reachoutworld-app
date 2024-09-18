import 'package:data_app/account_settings.dart';
import 'package:data_app/password_recovery_screen.dart';
import 'package:data_app/privacy_policy_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts package

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Space after AppBar
          _buildSettingsItem(
            title: 'Account Settings',
            onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSettingsPage(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            title: 'Change Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PasswordRecoveryScreen()),
              );
            },
          ),
          _buildSettingsItem(
            title: 'Linked Devices',
            onTap: () {
              // Handle Linked Devices tap
            },
          ),
          _buildSettingsItem(
            title: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      {required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: GoogleFonts.roboto(), // Apply Roboto font to the title
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16, // Make the forward arrow smaller
          ),
          onTap: onTap,
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: SettingsPage(),
//   ));
// }
