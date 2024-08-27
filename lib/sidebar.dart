import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String userName;
  final String userCountry;
  final String profileImage;

  const Sidebar(
      {super.key, required this.userName,
      required this.userCountry,
      required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/overlay_1.png'), // Replace with your background image path
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
                      backgroundImage: AssetImage(profileImage),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          userCountry,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // IconButton(
                    //   icon: Image.asset('assets/icon/edit.png',
                    //       width: 32, height: 32), // Adjust the size here
                    //   onPressed: () {
                    //     // Handle edit profile icon press
                    //   },
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    _buildDrawerItem(
                        'assets/icon/account.png', 'Account Settings',
                        onTap: () {}),
                    _buildDrawerItem('assets/icon/link_account.png',
                        'Linked Social Media Accounts',
                        onTap: () {}),
                    // _buildDrawerItem(
                    //     'assets/icon/leaderboard.png', 'Leaderboard',
                    //     onTap: () {}),
                    _buildDrawerItem('assets/icon/feedback.png', 'Feedback',
                        onTap: () {}),
                    _buildDrawerItem(
                        'assets/icon/settings.png',  'Settings',
                        onTap: () {}),
                    _buildDrawerItem('assets/icon/delete.png', 'Deactivate Account',
                        onTap: () {}),
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
            color: isLogout ? Colors.orange : Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
