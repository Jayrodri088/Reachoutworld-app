import 'package:data_app/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Sidebar extends StatelessWidget {
  final String userName;
  final String userCountry;
  final String profileImage; // This could be an asset or a file path

  const Sidebar({
    super.key,
    required this.userName,
    required this.userCountry,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    bool isAssetImage = !profileImage.startsWith('/'); // Check if it's an asset image or a file path

    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/overlay_1.png'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: isAssetImage
                          ? AssetImage(profileImage) as ImageProvider
                          : FileImage(File(profileImage)),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          userCountry,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    _buildDrawerItem(
                      'assets/icon/feedback.png',
                      'Feedback',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      'assets/icon/logout.png',
                      'Log Out',
                      isLogout: true,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String imagePath, String title,
      {bool isLogout = false, required Function()? onTap}) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 30,
        height: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: isLogout ? const Color.fromARGB(255, 32, 55, 187) : Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}