import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'settings.dart';
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
    const String url =
        'http://apps.qubators.biz/reachoutworlddc/dashboard.php'; // Your backend URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          _userName = data['name'];
          _userCountry = data['country'];
          _profileImageUrl = data['profile_picture_url'];
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
        // Update the profile image locally, even if the upload fails
        _profileImageUrl = _imageFile!.path;
      });
      await _uploadProfileImage(_imageFile!);
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    const url =
        'http://apps.qubators.biz/reachoutworlddc/profile.php'; // Your backend URL
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user_id'] = widget.userId;
    request.files
        .add(await http.MultipartFile.fromPath('profile_picture', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);

      if (result['status'] == 'success') {
        setState(() {
          //Done by Jay
          _profileImageUrl = result['profile_picture_url'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Image upload failed')),
        );
        print('Error details: ${result['error']}');
        print('Temporary file path: ${result['tmp_name']}');
        print('Target file path: ${result['target_file']}');
        print('Upload error code: ${result['upload_error']}');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: Sidebar(
        userName: _userName ?? 'Loading...',
        userCountry: _userCountry ?? 'Loading...',
        profileImage: _profileImageUrl ??
            'assets/profile_1.webp', // Fallback to default image
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardContent(
            userId: widget.userId,
            userName: _userName ?? 'User', // Pass userName
            userCountry: _userCountry ?? 'Country', // Pass userCountry
            profileImageUrl: _profileImageUrl ??
                'assets/profile_1.webp', // Pass profile image URL
            pickImageFunction: _pickImage, // Pass the _pickImage function
          ),
          const WalletScreen(),
          RecentActivitiesScreen(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem('assets/icon/home.png', 'Home', 0),
          _buildBottomNavigationBarItem(
              'assets/icon/wallet_1.png', 'Wallet', 1),
          _buildBottomNavigationBarItem(
              'assets/icon/history_1.png', 'History', 2),
          _buildBottomNavigationBarItem(
              'assets/icon/settings_3.png', 'Settings', 3),
        ],
        selectedItemColor: Color.fromARGB(255, 32, 55, 187),
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
                color: Color.fromARGB(255, 32, 55, 187),
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
  final String userId;
  final String userName;
  final String userCountry;
  final String profileImageUrl;
  final VoidCallback pickImageFunction; // Callback to pickImage function

  const DashboardContent({
    super.key,
    required this.userId,
    required this.userName,
    required this.userCountry,
    required this.profileImageUrl,
    required this.pickImageFunction, // Accept the pickImage function
  });

  @override
  Widget build(BuildContext context) {
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
                onTap: pickImageFunction, // Use the passed function
                child: CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage: FileImage(
                      File(profileImageUrl)), // Updated to use FileImage
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userCountry,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
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
            color: Color.fromARGB(255, 32, 55, 187),
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
              mainAxisSpacing: screenHeight * 0.02,
              crossAxisSpacing: screenWidth * 0.02,
              children: [
                _buildGridItem(context, 'assets/icon/capture_form.png',
                    'Data Capture', DataCaptureForm(userId: userId)),
                _buildGridItem(context, 'assets/icon/leaderboard.png',
                    'Leader board', const LeaderboardScreen()),
                _buildGridItem(context, 'assets/icon/statistics.png',
                    'Statistics', const StatisticsScreen()),
                _buildGridItem(context, 'assets/icon/capture.png',
                    'Media Capture', CameraScreen(userId: int.parse(userId))),
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
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
