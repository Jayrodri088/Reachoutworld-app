import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'camera_screen.dart';
import 'sidebar.dart';
import 'data_capture_form.dart';
import 'leaderboard_screen.dart';
import 'statistics_screen.dart';
import 'recent_activities_screen.dart';
import 'wallet_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userId; // Pass userId to fetch data

  const DashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  File? _imageFile;
  String? _profileImageUrl;
  String? _userName;
  String? _userCountry;
  final ImagePicker _picker = ImagePicker();

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardContent(),
    const WalletScreen(),
    RecentActivitiesScreen(),
    const Center(child: Text('Settings Screen Placeholder')),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchUserData() async {
    const String url = 'http://10.11.0.106/reachoutworlddc/dashboard.php'; // Your backend URL
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': widget.userId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          _userName = data['name'];
          _userCountry = data['country'];
          _profileImageUrl = data['profile_image_url'];
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadProfileImage(_imageFile!);
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    const url = 'http://10.11.0.106/reachoutworlddc/profile.php'; // Your backend URL
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('profile_picture', image.path));
    request.fields['user_id'] = widget.userId;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);

      if (result['status'] == 'success') {
        setState(() {
          _profileImageUrl = result['profile_image_url'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Image upload failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(
        userName: _userName ?? 'Loading...',
        userCountry: _userCountry ?? 'Loading...',
        profileImage: _profileImageUrl ?? 'assets/profile_1.webp',
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem('assets/icon/home.png', 'Home', 0),
          _buildBottomNavigationBarItem('assets/icon/wallet_1.png', 'Wallet', 1),
          _buildBottomNavigationBarItem('assets/icon/history_1.png', 'History', 2),
          _buildBottomNavigationBarItem('assets/icon/settings_3.png', 'Settings', 3),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: _selectedIndex == index
          ? Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(172, 245, 151, 10),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            )
          : Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
      label: label,
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userName = arguments['userName'] ?? 'Unknown';
    final String userCountry = arguments['userCountry'] ?? 'Unknown';
    final String? profileImageUrl = arguments['profileImageUrl'];

    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Row(
            children: [
              Builder(builder: (context) {
                return IconButton(
                  icon: Image.asset(
                    'assets/icon/dashboard.png',
                    width: screenWidth * 0.1,
                    height: screenHeight * 0.05,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              const Spacer(),
              IconButton(
                icon: Image.asset(
                  'assets/icon/notification.png',
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.05,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Trigger image picking
                  (context as _DashboardScreenState)._pickImage();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl)
                      : const AssetImage('assets/profile_1.webp') as ImageProvider,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $userName',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userCountry,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.035),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
        Container(
          width: screenWidth,
          height: screenHeight * 0.02,
          decoration: const BoxDecoration(
            color: Color.fromARGB(204, 245, 151, 10),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              bottom: screenHeight * 0.04,
            ),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing:
                  screenHeight * 0.02,
              crossAxisSpacing:
                  screenWidth * 0.02,
              children: [
                _buildGridItem(context, 'assets/icon/capture_form.png',
                    'Data Capture', const DataCaptureForm()),
                _buildGridItem(context, 'assets/icon/leaderboard.png',
                    'Leader board', const LeaderboardScreen()),
                _buildGridItem(context, 'assets/icon/statistics.png',
                    'Statistics', const StatisticsScreen()),
                _buildGridItem(context, 'assets/icon/capture.png',
                    'Media Capture', const CameraScreen()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, String imagePath, String title,
      [Widget? destination]) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.black54,
      child: InkWell(
        onTap: destination != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              }
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: screenWidth * 0.15,
              height: screenHeight * 0.1,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              title,
              style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
